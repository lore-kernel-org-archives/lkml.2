Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0KLDQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:16:10 -0500
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:4175
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab0KLDQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:16:05 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] fsldma: add support to 36-bit physical address
Date: Fri, 12 Nov 2010 11:16:46 +0800
Message-ID: <F9BD3E0A8083BE4ABAA94D7EDD7E3F6339D5ED@zch01exm26.fsl.freescale.net>
In-Reply-To: <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] fsldma: add support to 36-bit physical address
Thread-Index: AcuBl6G+cKeNGvhMSLWOgx0eJyTNgAAf1USg
References: <1289477789-10651-1-git-send-email-leoli@freescale.com> <54AAF9B7-9533-45B8-9C49-A964203AF707@kernel.crashing.org>
From: Li Yang-R58472 <r58472@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: <dan.j.williams@intel.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Subject: Re: [PATCH v2] fsldma: add support to 36-bit physical address
>
>
>On Nov 11, 2010, at 6:16 AM, Li Yang wrote:
>
>> Expand the dma_mask of fsldma device to 36-bit, indicating that the
>> DMA engine can deal with 36-bit physical address and does not need the
>> SWIOTLB to create bounce buffer for it when doing dma_map_*().
>>
>> Signed-off-by: Li Yang <leoli@freescale.com>
>> ---
>> Add more detailed commit message
>>
>> drivers/dma/fsldma.c |    4 +++-
>> 1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index
>> cea08be..8c79b37 100644
>> --- a/drivers/dma/fsldma.c
>> +++ b/drivers/dma/fsldma.c
>> @@ -1,7 +1,7 @@
>> /*
>>  * Freescale MPC85xx, MPC83xx DMA Engine support
>>  *
>> - * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
>> + * Copyright (C) 2007-2010 Freescale Semiconductor, Inc. All rights
>reserved.
>>  *
>>  * Author:
>>  *   Zhang Wei <wei.zhang@freescale.com>, Jul 2007
>> @@ -1338,6 +1338,8 @@ static int __devinit fsldma_of_probe(struct
>platform_device *op,
>> 	fdev->common.device_control = fsl_dma_device_control;
>> 	fdev->common.dev = &op->dev;
>>
>> +	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
>> +
>
>Is there any reason we shouldn't set DMA_BIT_MASK(64) since the DMA block
>programming model allows the address to be 64-bits?

The current code is only verified on chips with 36-bit physical address.  I'm not sure if the driver can work without any change on the 64-bit chip, although the register model suggests it can work well with 64-bit.  If you can confirm that it's compatible with the block on 64-bit chip, then we can change it to 64 bit dma mask.

- Leo

