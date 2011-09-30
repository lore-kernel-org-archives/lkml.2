Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1I3JKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:10:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32886 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755293Ab1I3JKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:10:18 -0400
Date: Fri, 30 Sep 2011 10:07:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm00@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -next] x86 mrst: fix build error when X86_MRST is not
 enabled
Message-ID: <20110930100704.6ea882c8@lxorguk.ukuu.org.uk>
In-Reply-To: <20110929161040.41f23573.akpm00@gmail.com>
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
	<4E84D684.107@xenotime.net>
	<20110929235708.1bbd1166@lxorguk.ukuu.org.uk>
	<20110929161040.41f23573.akpm00@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This breaks Medfield so NAK
> > 
> > The correct behaviour should be 
> > 
> > INTEL_MID defined -> mrst_cpu_chip has meaning
> > INTEL_MID not defined -> mrst_identify_chip is 0
> > 
> > your change makes it 0 for Medfield which means it will crash on boot.
> 
> Randy's patch is an attempt to fix Mathias's "x86: rtc: don't register
> a platform RTC device for Intel MID platforms".

NAK this.

> I'm tempted to do a mass droppage, but then some of the patches might
> get forever lost.

Randy's patch breaks Medfield, simply because he's seeing an incomplete
set of merges. The stuff the x86 maintainers were sent already deals with
this. It's all simply a case of waiting for the trees to get back into
sync, at which point platform/x86/mrst will get built for INTEL_MID
general case.

> Could we please get some x86 maintainers on deck??

Well currently x86@kernel.org is undeliverable so that won't help you.

Alan
