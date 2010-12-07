Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0LGCMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:12:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50870 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0LGCMv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:12:51 -0500
Date: Mon, 6 Dec 2010 21:12:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Airlie <airlied@redhat.com>
Cc: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] Utilize the PCI API in the AGP framework.
Message-ID: <20101207021227.GA31774@dumpdata.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
 <1291680126.8232.5.camel@clockmaker-el6>
 <20101207004844.GA31478@dumpdata.com>
 <1291684609.8232.8.camel@clockmaker-el6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291684609.8232.8.camel@clockmaker-el6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay reading that I'm not sure you've started at the right end.

I actually have all of those patches ready but figured I would start
from the AGP side..
> 
> I just read 601341, and it concerns nouveau, which shouldn't on the hw
> described be touching AGP at all. Its a PCIE machine, so the DRM/TTM
> code won't use any of the AGP paths.

I think most of them do touch PCIe cards. I swore that there were
some AGP users out there, maybe they aren't on those bugs - let me search
my mail archive. Maybe it just me who still uses AGP...
> 
> Now if we have fixes for TTM/nouveau/radeon that make it work under Xen
> then that is a whole different story, however these patches are not
> those.

Nope. I just posted them: https://lkml.org/lkml/2010/12/6/516

> 
> I'd suggest you reverse the priority, of the comment
> 
> a) Fix the GART/AGP backend (so drivers/char/agp/*.c) so they use the
> PCI API.
>    Only the i915 and higher are using the PCI API and I've some of the older
>    boxes with i860 so can actually test it.
>  b) Fix the TTM to use the DMA API.
>  c) Lastly, get rid of _PAGE_IOMAP so we don't have to depend on radeon/nouveau/etc
>    to set the proper _PAGE_IOMAP on the PFNs/BARs..
> 
> to do c, then b, and finally figure out if anyone cares about a, unless there is a major dependency in the code that requires this ordering.

There is a patch for c) that is nice and simple:
http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=f5d630621f6616a8a14438c047332742e77c0739

but we are working on making that obsolete by .. well I can go in details
but it still is just on pieces of paper.
> 
> Dave.
