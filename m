Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2LLMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:39:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47475 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2LLMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:39:04 -0500
Message-ID: <50C87AE1.9000708@ozlabs.ru>
Date: Wed, 12 Dec 2012 23:38:57 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vfio powerpc: enabled on powernv platform
References: <1354901926.3224.96.camel@bling.home> <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1355315657-31153-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

I posted other pair of patches. While debugging and testing my stuff I 
implemented some rough hack to support IOMMU mappings without passing those 
hypercalls to the QEMU, this is why I moved pieces of code around - want to 
support both QEMU-VFIO and kernel optimized H_PUT_TCE handler.



On 12/12/12 23:34, Alexey Kardashevskiy wrote:
> This patch initializes IOMMU groups based on the IOMMU
> configuration discovered during the PCI scan on POWERNV
> (POWER non virtualized) platform. The IOMMU groups are
> to be used later by VFIO driver (PCI pass through).
>
> It also implements an API for mapping/unmapping pages for
> guest PCI drivers and providing DMA window properties.
> This API is going to be used later by QEMU-VFIO to handle
> h_put_tce hypercalls from the KVM guest.
>
> Although this driver has been tested only on the POWERNV
> platform, it should work on any platform which supports
> TCE tables.
>
> To enable VFIO on POWER, enable SPAPR_TCE_IOMMU config
> option and configure VFIO as required.
>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---


-- 
Alexey
