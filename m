Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0HWRxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:53:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:34221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0HWRxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:53:53 -0400
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
Date: Mon, 23 Aug 2010 19:53:41 +0200
Message-ID: <1282586021.2605.2106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 10:34 -0700, Linus Torvalds wrote:
> It's also
> dubious as a way to pin particular pages in the page tables, because
> it's not necessarily something that the semantics guarantee
> (historically mlock just guarantees that they won't be swapped out,
> not that they will necessarily maintain some particular mapping). 

Quite so, and esp. now that page migration gets used more with all that
memory compaction stuff that got merged.
