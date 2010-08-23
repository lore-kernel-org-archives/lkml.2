Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0HWT0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:26:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:36417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab0HWT0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:26:53 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Jackson <ijackson@chiark.greenend.org.uk>,
        Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <4C72CAA7.5070202@goop.org>
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
	 <4C72C2E9.3070408@goop.org> <1282590457.2605.2200.camel@laptop>
	 <4C72CAA7.5070202@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 21:26:32 +0200
Message-ID: <1282591592.2605.2221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 12:23 -0700, Jeremy Fitzhardinge wrote:
> On 08/23/2010 12:07 PM, Peter Zijlstra wrote:
> > mlock() simply avoids major faults, nothing more.
> >
> > I think both page migration and page-out for shared pages where some
> > maps are !mlocked can cause unmaps and thus minor faults.
> >
> > mlock and dirty do not interact, they will still be cleaned/written out
> > as normal.
> 
> So mlock is useless for preventing secret stuff from being written to disk.

Well, if you put your sekrit in a file map, sure.

Use a mmap(MAP_ANONYMOUS|MAP_LOCK) and madvise(MADV_DONTFORK) for your
sekrits.
