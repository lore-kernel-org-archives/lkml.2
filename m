Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab0GUXo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:44:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:48062 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab0GUXoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:44:54 -0400
Date: Thu, 22 Jul 2010 08:44:42 +0900
To: akataria@vmware.com
Cc: fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, ak@linux.intel.com,
        lenb@kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, petr@vmware.com
Subject: Re: swiotlb detection should be memory hotplug aware ?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1279732414.10874.6.camel@ank32.eng.vmware.com>
References: <1279664097.21596.43.camel@ank32.eng.vmware.com>
	<20100721135750Z.fujita.tomonori@lab.ntt.co.jp>
	<1279732414.10874.6.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100722084413I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 08:44:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 10:13:34 -0700
Alok Kataria <akataria@vmware.com> wrote:

> > Basically, you want to add hot-plug memory and enable swiotlb, right?
> 
> Not really, I am planning to do something like this, 
> 
> @@ -52,7 +52,7 @@ int __init pci_swiotlb_detect(void)
>  
>  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
>  #ifdef CONFIG_X86_64
> -	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> +	if (!no_iommu && (max_pfn > MAX_DMA32_PFN || hotplug_possible()))
>  		swiotlb = 1;

Always enable swiotlb with memory hotplug enabled? Wasting 64MB on a
x86_64 system with 128MB doesn't look to be a good idea. I don't think
that there is an easy solution for this issue though.
