Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2ABKIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 05:08:21 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34843 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2ABKIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 05:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <1324661918.1633.35.camel@vkoul-udesk3>
References: <1324051191-19507-1-git-send-email-javier.martin@vista-silicon.com>
	<1324661918.1633.35.camel@vkoul-udesk3>
Date: Mon, 2 Jan 2012 11:08:17 +0100
Message-ID: <CACKLOr0fVMknA+HAbgn3d9_f9tdz4L2Z9Bx4yMU7eLmr1mdXBA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: Add support for MEMCPY for imx-dma.
From: javier Martin <javier.martin@vista-silicon.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        s.hauer@pengutronix.de, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,
thank you for your review.

On 23 December 2011 18:38, Vinod Koul <vinod.koul@intel.com> wrote:
>> @@ -328,6 +329,37 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>>       return &imxdmac->desc;
>>  }
>>
>> +static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
>> +     struct dma_chan *chan, dma_addr_t dest,
>> +     dma_addr_t src, size_t len, unsigned long flags)
>> +{
>> +     struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>> +     struct imxdma_engine *imxdma = imxdmac->imxdma;
>> +     int ret;
>> +
>> +     dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
>> +                     __func__, imxdmac->channel, src, dest, len);
>> +
>> +     if (imxdmac->status == DMA_IN_PROGRESS)
>> +             return NULL;
>> +
>> +     imxdmac->status = DMA_IN_PROGRESS;
> why? prepare doesn't mean DMA is in progress. You can get multiple
> descriptors for same channel by calling prepare multiple times.
> Even one descriptor can be memcpy whereas other is slave...
> In issue_pending this should be moved to DMA_IN_PROGRESS

According to the original developer of this file it only supports a
single descriptor. Please, take a look at the following function:

static void imxdma_issue_pending(struct dma_chan *chan)
{
	/*
	 * Nothing to do. We only have a single descriptor
	 */
}


Also, the same behavior is present in the other prepare functions:
"imxdma_prep_slave_sg" and "imxdma_prep_dma_cyclic".

I think the less painful approach here is merging my patch so that
multiple descriptors support can be added later.

--
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
