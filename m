Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1IQP4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:56:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57659 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1IQP4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4za8HZ6hoyRyU=NR8TXhN+iFOQvfOeA1F_GTH6h6Zs+=A@mail.gmail.com>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
	<CABb+yY13Xum=nU2eD+DJ7Uv_8ppE+UKFUA6KD_4CP+eDG5rAaQ@mail.gmail.com>
	<CAGsJ_4za8HZ6hoyRyU=NR8TXhN+iFOQvfOeA1F_GTH6h6Zs+=A@mail.gmail.com>
Date: Sat, 17 Sep 2011 21:21:27 +0530
Message-ID: <CAJe_Zhcq4SS0pbQ2ZoUGfRFX90WVs=7HzwaOVv880XQPz27zfg@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Barry Song <Baohua.Song@csr.com>,
        Arnd Bergmann <arnd@arndb.de>, Rongjun Ying <rongjun.ying@csr.com>,
        vinod.koul@intel.com, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2011 20:27, Barry Song <21cnbao@gmail.com> wrote:
>>> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
>>> +       struct dma_slave_config *config)
>>> +{
>>> +       u32 addr, direction;
>>> +       unsigned long flags;
>>> +
>>> +       switch (config->direction) {
>>> +       case DMA_FROM_DEVICE:
>>> +               direction = 0;
>>> +               addr = config->dst_addr;
>>> +               break;
>>> +
>>> +       case DMA_TO_DEVICE:
>>> +               direction = 1;
>>> +               addr = config->src_addr;
>>> +               break;
>>> +
>>> +       default:
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
>>> +               (config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
>>> +               return -EINVAL;
>>> +
>>> +       spin_lock_irqsave(&schan->lock, flags);
>>> +       schan->addr = addr;
>>> +       schan->direction = direction;
>>> +       schan->mode = (config->src_maxburst == 4 ? 1 : 0);
>>> +       spin_unlock_irqrestore(&schan->lock, flags);
>>> +
>>> +       return 0;
>>> +}
>> You don't need to pass as much info via dma_slave_config as you do here.
>>
>> dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
>> !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE
>
> it seems direct DMA_TO_DEVICE/DMA_FROM_DEVICE is more feasible and
> explict to me.

> "dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc" is probably
> DMA_TO_DEVICE, but it is not always true for all scenerios to all kinds of devices.
For which scenarios do you think it won't hold (remember that dmac already
knows if the channel is SLAVE or not) ?
