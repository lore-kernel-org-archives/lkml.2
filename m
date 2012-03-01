Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab2CAK2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:28:21 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54431 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036Ab2CAK2U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:28:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.112.101.130 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
In-Reply-To: <20120301101904.GA3852@pengutronix.de>
References: <1330445298-3522-1-git-send-email-javier.martin@vista-silicon.com>
	<1330445298-3522-3-git-send-email-javier.martin@vista-silicon.com>
	<20120301101904.GA3852@pengutronix.de>
Date: Thu, 1 Mar 2012 11:28:18 +0100
Message-ID: <CACKLOr2bFgSUW+oXgFReHt6ZS+t7atMJ6nzDgF4-e9cRyOYX4w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dmaengine: Add support for multiple descriptors
 for imx-dma.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 1 March 2012 11:19, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, Feb 28, 2012 at 05:08:18PM +0100, Javier Martin wrote:
>> dmaengine specifies the possibility that several descriptors
>> can be queued for transfer. It also indicates that tasklets
>> must be used for DMA callbacks.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>
> Have you tested this patch with audio?

Yes,
I have a test battery which tests audio, mmc, runs dmatest module and
a custom mem2mem video device I'm developing.

>
>> +static int imxdma_xfer_desc(struct imxdma_desc *d)
>> +{
>> +     struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
>> +     int ret;
>> +
>> +     /* Configure and enable */
>> +     switch (d->type) {
>> +     case IMXDMA_DESC_MEMCPY:
>> +             ret = imx_dma_config_channel(imxdmac->imxdma_channel,
>> +                                       d->config_port, d->config_mem, 0, 0);
>> +             if (ret < 0)
>> +                     return ret;
>> +             ret = imx_dma_setup_single(imxdmac->imxdma_channel, d->src,
>> +                                        d->len, d->dest, d->dmamode);
>> +             if (ret < 0)
>> +                     return ret;
>> +             break;
>> +     case IMXDMA_DESC_CYCLIC:
>> +             ret = imx_dma_setup_progression_handler(imxdmac->imxdma_channel,
>> +                                                     imxdma_progression);
>> +             if (ret < 0)
>> +                     return ret;
>
> You fall through here. Is this intended? If yes, a comment would be good
> here.

Yes it is. cyclic is the same as slave_sg with the add-on of the
progression handler and a specific configuration of the sglist which
is done in 'imxdma_prep_dma_cyclic'.
Do you want me to send a new version with a comment on the matter?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
