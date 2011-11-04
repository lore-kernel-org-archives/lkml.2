Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab1KDTUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 15:20:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34320 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1KDTUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 15:20:44 -0400
Date: Fri, 4 Nov 2011 15:24:51 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v2.2 or [GIT PULL]
 (stable/ttm.dma_pool.v2.3) for 3.3
Message-ID: <20111104192451.GE2015@homer.localdomain>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
 <20111104183110.GC2015@homer.localdomain>
 <20111104184453.GB1616@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104184453.GB1616@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 02:44:53PM -0400, Konrad Rzeszutek Wilk wrote:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3
> > > 
> > 
> > On what hw did you tested ? With and without xen ? Here radeon
> 
> On AMD and Intel. And with both Nvidia and Radeon cards.
> 64-bit cards (I have a patch where I forced the 64-bit card to use
> the TTM DMA pool code to test) and 32-bit cards (ATI ES1000)
> 
> On baremetal and Xen. Um, Fedora Core 16 as distro.
> 
> Oh, and I also tried PPC (Power Mac 4) but could not get it to boot
> the 3.1 kernel. Something with the LILO grub loader did not work.
> 
> > that doesn't need dma32 doesn't work when forcing swiotlb which
> > kind of expected i guess. Should we expose if swiotlb is enabled
> 
> You did 'swiotlb=force' ?
> > forced so we use dma pool in such case ?

Issue is that when booted without force swiotlb_nr_tlb still return
positive thus we endup using the dma pool path.

Cheers,
Jerome

> Hm, it shoudl have enabled itself. The swiotlb_nr_tlb would return some
> contents and we would.. Oh, you mean you did a 64-bit card _and_
> did swiotlb=force. And since the rdev->dma32 was set to zero it
> did _not_ use the TTM DMA pool.
> 
> Right. I did not do it initially just so that I could limit the scope
> in case I messed up something in the code. But the code has the
> 'no_dma' parameter, so it can easily turn off the DMA TTM code.
> 
> So, to answer your question - sure, we can ignore the rdev_dma32 and
> just use the the swiotlb_nr_tlb to check.
> 
> BTW, thank you for taking a spin with these patches and rebasing them
> on top of yours. I am going to start testing them and reviewing the
> latest batch you sent on Monday.
