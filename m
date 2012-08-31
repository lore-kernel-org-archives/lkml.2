Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2HaCxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 22:53:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58523 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2HaCxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 22:53:07 -0400
Message-ID: <5040270F.6060302@gmail.com>
Date: Thu, 30 Aug 2012 21:53:03 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: add devres version of of_iomap
References: <1346340744-22218-1-git-send-email-m-karicheri2@ti.com> <503FB074.7080702@gmail.com> <3E54258959B69E4282D79E01AB1F32B7041AD91C@DFLE12.ent.ti.com>
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041AD91C@DFLE12.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 05:09 PM, Karicheri, Muralidharan wrote:
>>> -----Original Message-----
>>> From: Rob Herring [mailto:robherring2@gmail.com]
>>> Sent: Thursday, August 30, 2012 2:27 PM
>>> To: Karicheri, Muralidharan
>>> Cc: grant.likely@secretlab.ca; devicetree-discuss@lists.ozlabs.org; linux-
>>> kernel@vger.kernel.org
>>> Subject: Re: [PATCH] of: add devres version of of_iomap
>>>
>>> On 08/30/2012 10:32 AM, Murali Karicheri wrote:
>>>> This adds devres version of the of_iomap() to allow resource to be cleaned
>>>> through devres.
>>>
>>> If you have a struct device, then don't you already have a resource and
>>> can just use devm_ioremap in a driver? New drivers should not be using
>>> of_iomap.
>>>
> 
> That is the point. If you do a grep under driver, there are many drivers using the pattern
> like this. This helper function is mean to replace this code.
> 
> From dma/sirf-dma.c
> 
>         ret = of_address_to_resource(dn, 0, &res);
>         if (ret) {
>                 dev_err(dev, "Error parsing memory region!\n");
> 	       goto error;
>         }
> 
>         regs_start = res.start;
>         regs_size = resource_size(&res);
> 
>         base = devm_ioremap(dev, regs_start, regs_size);
>         if (!base) {
>                 dev_err(dev, "Error mapping memory region!\n");
> 	       goto error;
>         }
> 

That's wrong and should be fixed. The resource is already setup and
available to the probe function.

> Other instances.
> 
> edac/mpc85xx_edac.c
> media/video/fsl-viu.c
> mtd/nand/mpc5121_nfc.c

All PPC drivers that used the old of_platform_driver and also need to be
updated.

> 
> Some of these code uses devm_request_mem_region() as well. Isn't a good idea to add this helper
> that can be called by new drivers to replace this sequence? I could update the patch to do this call
> as well?

devm_request_and_ioremap

Rob

