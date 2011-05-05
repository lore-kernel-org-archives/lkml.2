Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1EEImi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:42:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63286 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1EEImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QKQL4EJhyhg4WQ09bY/4t+OQUnoGO/MTvrQmsbXL1rQvoSHZI3rMam2UTt5NljRk+s
         dgqjP4xbkG+ejtJ0xBceond8i03takjVnvuh1lbIRhRteRYiVcwIkC2iQn0m3P0elLI4
         mC6ImXzwZmxumh3rYpHY+h9zKDcmE1FywJYUw=
Message-ID: <4DC263C6.1040805@gmail.com>
Date: Thu, 05 May 2011 16:45:58 +0800
From: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com>	 <1304316260.1589.2.camel@vkoul-udesk3>  <4DBF66C0.9020600@gmail.com> <1304395926.1589.27.camel@vkoul-udesk3> <4DBFA152.8000709@gmail.com> <4DC02622.90000@intel.com>
In-Reply-To: <4DC02622.90000@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年05月03日 23:58, Dan Williams 写道:
>
>> Do you mean that if I have mapped the mmio, I can' use I/OAT dma
>> transfer to this region any more?
>> I can use memcpy to copy data, but it consumes lots of cpu as PCI access
>> is too slow.
>> If I can use i/oat dma and asyc_tx api to do the job, the performance
>> should be imporved.
>> Thanks
>
>
> The async_tx api only supports memory-to-memory transfers.  To write 
> to mmio space with ioatdma you would need a custom method, like the 
> dma-slave support in other drivers, to program the descriptors with 
> the physical mmio bus address.
>
> -- 
> Dan
Thanks.
I directly read pci bar address and program it into descriptors, ioatdma 
works.
Some problem is, when PCI transfer failed (Using a NTB connect to 
another system, and the system power down),
ioatdma will cause kernel oops.

BUG_ON(is_ioat_bug(chanerr));
in drivers/dma/ioat/dma_v3.c, line 365

It seems that HW reports a 'IOAT_CHANERR_DEST_ADDR_ERR', and drivers 
can't recover from this situation.
What does dma-slave mean? Just like DMA_SLAVE flag existing in other DMA 
drivers?

