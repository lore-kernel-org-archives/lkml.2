Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0HWSAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:00:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HWSAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:00:01 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Jackson <ijackson@chiark.greenend.org.uk>, Greg KH <gregkh@suse.de>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	 <19570.38608.79434.179797@chiark.greenend.org.uk>
	 <1282580751.2605.1997.camel@laptop>
	 <19570.44367.719276.128881@chiark.greenend.org.uk>
	 <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 19:59:45 +0200
Message-ID: <1282586385.2605.2119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 10:34 -0700, Linus Torvalds wrote:
> I suspect that if you use mlock for _any_ other reason than protecting
> a particular very sensitive piece of information, you should use
> mlockall(MCL_FUTURE). IOW, if you use mlock because you have realtime
> issues, there is no excuse to ever use anything else, imho. And even
> then, I guarantee that things like copy-on-write is going to be
> "interesting".
> 
> I realize that people hate mlockall() (and particularly MCL_FUTURE),
> and yes, it's a bloated thing that you can't reasonably use on a large
> process. But dammit, if you have RT issues, you shouldn't _have_ some
> big bloated process. You should have a small statically linked server
> that is RT, and nothing else. 

Us real-time people have been telling people to not use mlockall() at
all.

While small !glibc statically linked RT components using shared memory
interfaces to !RT apps could work its not how people actually write
their apps. They write big monolithic threaded apps where some threads
are RT.

[ in part because there doesn't seem to be a usable !glibc
libpthread/librt implementation out there, in part because people use
crap like Java-RT ]


