Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1IQPdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:33:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1IQPdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110917150246.GH16381@n2100.arm.linux.org.uk>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com> <20110917150246.GH16381@n2100.arm.linux.org.uk>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 17 Sep 2011 23:33:31 +0800
Message-ID: <CAGsJ_4ySwfuaa1tbMcQkYHQQw61+-ajXwhxr_5xOxxKmn+aDog@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Barry Song <Baohua.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Rongjun Ying <rongjun.ying@csr.com>, vinod.koul@intel.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/17 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Fri, Sep 16, 2011 at 02:56:00AM -0700, Barry Song wrote:
>> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
>> +     struct dma_slave_config *config)
>> +{
>> +     u32 addr, direction;
>> +     unsigned long flags;
>> +
>> +     switch (config->direction) {
>
> config->direction is deprecated, please don't use it.

ok.

>
>> +     case DMA_FROM_DEVICE:
>> +             direction = 0;
>> +             addr = config->dst_addr;
>> +             break;
>> +
>> +     case DMA_TO_DEVICE:
>> +             direction = 1;
>> +             addr = config->src_addr;
>> +             break;
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
>> +             (config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
>> +             return -EINVAL;
>> +
>> +     spin_lock_irqsave(&schan->lock, flags);
>> +     schan->addr = addr;
>> +     schan->direction = direction;
>> +     schan->mode = (config->src_maxburst == 4 ? 1 : 0);
>
> Please store the source address, destination address, and mode separately
> for each direction.  You should then select from that at prepare time.

the dmac has fixed route. every channel has fixed function. one
channel is for one device and one direction. for example, spi0 can
have two fixed channel: spi0-tx, spi0-rx.
then for every schan, device address is always fixed and we don't care
it at all. we only need to write the memory address to dmac address
register.

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>

-barry
