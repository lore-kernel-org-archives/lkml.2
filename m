Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2ASJaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:30:01 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:44116
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756059Ab2ASJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:29:54 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F17E2E7.2080300@freescale.com>
Date: Thu, 19 Jan 2012 17:31:19 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <vinod.koul@intel.com>, <alsa-devel@alsa-project.org>,
        <artem.bityutskiy@intel.com>, <b29396@freescale.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <w.sang@pengutronix.de>, <linux-mtd@lists.infradead.org>,
        <shawn.guo@linaro.org>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <LW@KARO-electronics.de>
Subject: Re: [PATCH 06/10] MXS-DMA : add more flags for MXS-DMA
References: <1326953767-24155-1-git-send-email-b32955@freescale.com> <1326953767-24155-7-git-send-email-b32955@freescale.com> <20120119090238.GU1068@n2100.arm.linux.org.uk>
In-Reply-To: <20120119090238.GU1068@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
> Err, the 'flags' argument to device_prep_slave_sg() is supposed to be
> from the set of enum dma_ctrl_flags.  What this means is that your
> MXS_DMA_F_APPEND is equivalent to DMA_PREP_INTERRUPT, and
> MXS_DMA_F_WAIT4END is equivalent to DMA_CTRL_ACK.
>
thanks a lot.
I will reuse the dma_ctrl_flags in the next version.
> What this does is make your drivers completely dependent on your DMA
> engine implementation.  That's not a good idea when devices get
> reused in different SoCs.
>
Frankly speaking, the APBH-DMA is more coupled with the GPMI  then any 
other modules.
In the MX6Q, the GPMI is the ONLY user of APBH-DMA.
You even can see the NAND_LOCK bit in the DMA command structure which is 
only used by the GPMI
NAND controller,.


To Shawn & Wolfram:
    thanks very much for your comments.

Best Regards
Huang Shijie

> If you need to supply extra flags which aren't in the dma_ctrl_flags,
> at least make sure that they're using different bits.  For bonus points,
> also have your driver_check_  the DMA engine it's connected to before
> it passes these flags.
>


