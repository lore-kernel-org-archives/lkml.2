Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2FFIQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:16:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45025 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2FFIQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:16:05 -0400
Date: Wed, 6 Jun 2012 10:16:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>, iommu@lists.linux-foundation.org,
        mingo@elte.hu, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 2/2] iommu: dmar -- reserve mmio space used by IOMMU
Message-ID: <20120606081600.GB5991@gmail.com>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
 <1338845342-12464-3-git-send-email-ddutile@redhat.com>
 <1338849430.10884.288.camel@shinybook.infradead.org>
 <4FCD401D.9000304@redhat.com>
 <1338852196.26785.10.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338852196.26785.10.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> > well, one could argue it may be easier to claim the space 
> > reserved in the OS then making yet another hole in the 
> > available IO address space in the ACPI tables.
> 
> But how? It's got to work with operating systems that predate 
> the IOMMU. The registers *have* to be in a marked hole. If 
> *not*, then we should give a clear "YOUR BIOS IS BROKEN" 
> output like all the similar breakages, and do our best to work 
> around it.
> 
> Working around it is fine; I'm not suggesting that we should 
> WARN() *instead* of working around it.

So basically the patch-set is fine as-is, we just want a 
sufficiently nasty sounding warning message about the BIOS bug, 
with actionable output, something like:

     ... the kernel is sad because a buggy BIOS has not 
         marked IOMMU area xxx-yyy as reserved, working
         it around. You get to keep all the pieces and
         be more careful with remaining eye.

(or a functional equivalent thereof.)

this patch could be added as a third patch in the series, right?

> >   The BIOS's are getting better, but I've seen turtles run 
> >   faster... ;-) .
> 
> Thankfully, there are now some modern Intel systems on which 
> you can run Coreboot. This should be a huge benefit — you 
> should be able to build an up-to-date Tianocore and deploy it 
> as your Coreboot payload, rather than having to put up with 
> the crap that's on the system when you receive it.

If we could integrate Coreboot into the kernel and could build a 
bzImage that one could write into the BIOS flash image and thus 
have an updated and functional BIOS, that would be awesome.

People could actually write systems with proper 'every pixel is 
perfect' boot output and low latency behavior from the moment 
power is turned on to the first desktop GUI frame and such.

(With some fail safe mechanism for bugs.)

And ponies.

Thanks,

	Ingo
