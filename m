Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab0F0EVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 00:21:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:36943 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab0F0EVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 00:21:25 -0400
Date: Sun, 27 Jun 2010 13:20:45 +0900
To: mattst88@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       mcree@orcon.net.nz, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       dri-devel@lists.freedesktop.org, airlied@gmail.com,
       alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTimTOTM8Tt5A7eBVbxcYaGQVn_Q6-9hL8B1B4bjY@mail.gmail.com>
References: <AANLkTinG-5iKW5cigIQHPHRZuAMtG_xY-74XLL6vE5kb@mail.gmail.com>
	<20100622145805R.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTimTOTM8Tt5A7eBVbxcYaGQVn_Q6-9hL8B1B4bjY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20100627130717M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 27 Jun 2010 13:20:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 10:53:52 -0400
Matt Turner <mattst88@gmail.com> wrote:

> > Seems that the IOMMU can't find 128 pages. It's likely due to:
> >
> > - out of the IOMMU space (possibly someone doesn't free the IOMMU
> >  space).
> >
> > or
> >
> > - the mapping parameters (such as align) aren't appropriate so the
> >  IOMMU can't find space.
> >
> >
> >> Is this the cause of the bug we're seeing in the report [1]?
> >>
> >> Anyone know what's going wrong here?
> >
> >
> > I've attached a patch to print the debug info about the mapping
> > parameters.
> >
> >
> > diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
> > index d1dbd9a..17cf0d8 100644
> > --- a/arch/alpha/kernel/pci_iommu.c
> > +++ b/arch/alpha/kernel/pci_iommu.c
> > @@ -187,6 +187,10 @@ iommu_arena_alloc(struct device *dev, struct pci_iommu_arena *arena, long n,
> >        /* Search for N empty ptes */
> >        ptes = arena->ptes;
> >        mask = max(align, arena->align_entry) - 1;
> > +
> > +       printk("%s: %p, %p, %d, %ld, %lx, %u\n", __func__, dev, arena, arena->size,
> > +              n, mask, align);
> > +
> >        p = iommu_arena_find_pages(dev, arena, n, mask);
> >        if (p < 0) {
> >                spin_unlock_irqrestore(&arena->lock, flags);
> 
> Using this patch, I log the attached output.

Your system has 1GB iommu address space. I guess that it's enough for
KSM?

The parameters in the log looks good. But you got this log before you
started X?
