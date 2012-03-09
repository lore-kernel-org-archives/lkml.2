Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab2CIL5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:57:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39112 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2CIL5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120309110028.GB3852@pengutronix.de>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
	<1331130825-14947-2-git-send-email-javier.martin@vista-silicon.com>
	<20120309110028.GB3852@pengutronix.de>
Date: Fri, 9 Mar 2012 12:57:21 +0100
Message-ID: <CACKLOr0QOhy9-GbEOeU0ExYwDrcoPKcv2=W8-4hT6vM5oCOyBQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 March 2012 12:00, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Mar 07, 2012 at 03:33:33PM +0100, Javier Martin wrote:
>> It is mainly a simple merge changing the prefix of some
>> functions to fit the imx-dma namings.
>>
>> As there are no users of the old dma-v1.c api we can safely
>> remove this file.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>> @@ -633,11 +1127,8 @@ static int __exit imxdma_remove(struct platform_device *pdev)
>>
>>          dma_async_device_unregister(&imxdma->dma_device);
>>
>> -     for (i = 0; i < MAX_DMA_CHANNELS; i++) {
>> -             struct imxdma_channel *imxdmac = &imxdma->channel[i];
>> -
>> -              imx_dma_free(imxdmac->imxdma_channel);
>> -     }
>> +     for (i = 0; i < MAX_DMA_CHANNELS; i++)
>> +             free_irq(MX2x_INT_DMACH0 + i, NULL);
>
> This lacks a test for i.MX1/21/27. The above is correct for i.MX21/27,
> but on i.MX1 you have to free MX1_DMA_INT/MX1_DMA_ERR.

This series has only been tested for i.MX27. So, to those reviewing
the code, please pay special attention to i.MX1 part.

Sascha, thank you for your comment, I will fix it for the next version.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
