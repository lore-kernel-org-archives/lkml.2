Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2LLG7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:59:19 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52170 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2LLG7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:59:17 -0500
Message-ID: <50C82B3C.1060006@ozlabs.ru>
Date: Wed, 12 Dec 2012 17:59:08 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: implemented IOMMU driver for VFIO
References: <1354557206.1809.377.camel@bling.home>  <1354865693-8060-1-git-send-email-aik@ozlabs.ru> <1354899707.3224.86.camel@bling.home>
In-Reply-To: <1354899707.3224.86.camel@bling.home>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/12 04:01, Alex Williamson wrote:
>> +	case VFIO_IOMMU_MAP_DMA: {
>> +		vfio_iommu_spapr_tce_dma_map param;
>> +		struct iommu_table *tbl = container->tbl;
>> +		enum dma_data_direction direction;
>> +		unsigned long locked, lock_limit;
>> +
>> +		if (WARN_ON(!tbl))
>> +			return -ENXIO;
>> +
>> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
>> +
>> +		if (copy_from_user(&param, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (param.argsz < minsz)
>> +			return -EINVAL;
>> +
>> +		if ((param.flags & VFIO_DMA_MAP_FLAG_READ) &&
>> +				(param.flags & VFIO_DMA_MAP_FLAG_WRITE))
>> +			direction = DMA_BIDIRECTIONAL;
>> +		else if (param.flags & VFIO_DMA_MAP_FLAG_READ)
>> +			direction = DMA_TO_DEVICE;
>> +		else if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
>> +			direction = DMA_FROM_DEVICE;
>> +		else
>> +			return -EINVAL;
>
> flags needs to be sanitized too.  Return EINVAL if any unknown bit is
> set or else sloppy users may make it very difficult to make use of those
> flag bits later.


It already returns -EINVAL on any bit set except READ/WRITE, no?


-- 
Alexey
