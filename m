Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2LLOgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab2LLOge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:36:34 -0500
Message-ID: <1355322973.3224.203.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: implemented IOMMU driver for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Wed, 12 Dec 2012 07:36:13 -0700
In-Reply-To: <50C82B3C.1060006@ozlabs.ru>
References: <1354557206.1809.377.camel@bling.home>
	  <1354865693-8060-1-git-send-email-aik@ozlabs.ru>
	 <1354899707.3224.86.camel@bling.home> <50C82B3C.1060006@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 17:59 +1100, Alexey Kardashevskiy wrote:
> On 08/12/12 04:01, Alex Williamson wrote:
> >> +	case VFIO_IOMMU_MAP_DMA: {
> >> +		vfio_iommu_spapr_tce_dma_map param;
> >> +		struct iommu_table *tbl = container->tbl;
> >> +		enum dma_data_direction direction;
> >> +		unsigned long locked, lock_limit;
> >> +
> >> +		if (WARN_ON(!tbl))
> >> +			return -ENXIO;
> >> +
> >> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
> >> +
> >> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (param.argsz < minsz)
> >> +			return -EINVAL;
> >> +
> >> +		if ((param.flags & VFIO_DMA_MAP_FLAG_READ) &&
> >> +				(param.flags & VFIO_DMA_MAP_FLAG_WRITE))
> >> +			direction = DMA_BIDIRECTIONAL;
> >> +		else if (param.flags & VFIO_DMA_MAP_FLAG_READ)
> >> +			direction = DMA_TO_DEVICE;
> >> +		else if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
> >> +			direction = DMA_FROM_DEVICE;
> >> +		else
> >> +			return -EINVAL;
> >
> > flags needs to be sanitized too.  Return EINVAL if any unknown bit is
> > set or else sloppy users may make it very difficult to make use of those
> > flag bits later.
> 
> 
> It already returns -EINVAL on any bit set except READ/WRITE, no?

No.  I could pass flags ~0 through there to get a read/write mapping and
cause you problems if you later want to define another bit.  Thanks,

Alex

