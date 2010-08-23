Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0HWJWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:22:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:40931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0HWJWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:22:42 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Ian Campbell <ijc@hellion.org.uk>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 11:22:25 +0200
Message-ID: <1282555345.2605.1520.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-22 at 11:21 -0700, Linus Torvalds wrote:
> Doing hypercalls from user space on stuff that is on the stack,
> rather than just copying it to some stable area is dodgy. And I
> guarantee that doing the crazy mlock dance is slower than the copy, so
> it's complex, fragile, _and_ slow.
> 
That sounds broken too, not having read the initial problem and such, it
sounds like the hypercall would expect the pages to stay pinned and
mlock doesn't actually guarantee that at all.


