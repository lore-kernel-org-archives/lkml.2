Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2JRJHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:07:47 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:42505
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab2JRJHp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:07:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dIc89bh1432Id799hzz1202h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah107ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1155h)
Message-ID: <507FC796.7060401@freescale.com>
Date: Thu, 18 Oct 2012 17:10:46 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vinod Koul <vinod.koul@linux.intel.com>, <djbw@fb.com>,
        <khali@linux-fr.org>, <ben-linux@fluff.org>, <w.sang@pengutronix.de>,
        <cjb@laptop.org>, <dwmw2@infradead.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <shawn.guo@linaro.org>, <marex@denx.de>,
        <artem.bityutskiy@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH] dma: add new DMA control commands
References: <1350538335-29026-1-git-send-email-b32955@freescale.com> <1350541111.5263.3.camel@vkoul-udesk3> <507FA595.4020507@freescale.com> <20121018085208.GR21164@n2100.arm.linux.org.uk>
In-Reply-To: <20121018085208.GR21164@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月18日 16:52, Russell King - ARM Linux 写道:
> On Thu, Oct 18, 2012 at 02:45:41PM +0800, Huang Shijie wrote:
>> 于 2012年10月18日 14:18, Vinod Koul 写道:
>>> Why cant you do start (prepare clock etc) when you submit the descriptor
>>> to dmaengine. Can be done in tx_submit callback.
>>> Similarly remove the clock when dma transaction gets completed.
>> I ever thought this method too.
>>
>> But it will become low efficient in the following case:
>>
>>    Assuming the gpmi-nand driver has to read out 1024 pages in one
>> _SINGLE_ read operation.
>> The gpmi-nand will submit the descriptor to dmaengine per page. So with
>> your method,
>> the system will repeat the enable/disable dma clock 1024 time. At every
>> enable/disable dma clock,
>> the system has to enable the clock chain and it's parents ...
> And what if you stop using clk_prepare_enable(), and prepare the clock
> when the channel is requested and only use clk_enable() in the tx_submit
yes. it's a little better.
There is nearly no difference between the clk_prepare_enable() and 
clk_enable() in actually.
the clk_gate2_ops does not have any @->prepare.

thanks
Huang Shijie

> method?
>


