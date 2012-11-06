Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2KFM11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:27:27 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3047
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2KFM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:27:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI146fI1432Id799hzz1de0h1202h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 6 Nov 2012 20:52:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: yongd <yongd@marvell.com>
CC: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] mmc: esdhc: enable polling to detect card by
 itself
Message-ID: <20121106125253.GC27643@S2100-06.ap.freescale.net>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
 <1351589403-26398-2-git-send-email-yongd@marvell.com>
 <20121031152030.GE8100@S2100-06.ap.freescale.net>
 <5093BE95.6040709@marvell.com>
 <20121105015421.GA26512@S2100-06.ap.freescale.net>
 <509733D9.2060807@marvell.com>
 <20121105124809.GA27260@S2100-06.ap.freescale.net>
 <5098CF26.3060202@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5098CF26.3060202@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:49:42PM +0800, yongd wrote:
> From your info, we can see that on your platform, those pins (including
> power, clk, DATA) necessary for MMC_SEND_STATUS transaction still keep
> connected for some time just after the GPIO's level changes due to card
> removable. And if we remove the card very slowly, such time duration can be
> such long that the MMC_SEND_STATUS query can still succeed.
> 
I was not removing the card as slowly as you think. It's actually
a normal speed.  That's why I thought your patch breaks the
card-detection functionality before I found the cause.

> So I think we can add a proper delay(maybe 100ms) before the gpio interrupt
> triggers the MMC_SEND_STATUS query, and maybe this can probably fix this issue:-)
> 
I do not think it's a proper fixing.

<snip>

> Anyway, I 100% agree with you that for a ESDHC_CD_GPIO card, we shall query gpio
> state to know such card's presence rather than sending MMC_SEND_STATUS rudely.
> 
> But just as I mentioned before, I don't think using SDHCI_QUIRK_BROKEN_CARD_DETECTION
> as the flag to determine whether and how we can know card's presence before sending
> command is a proper way.
> 
> I haven't gotten any good idea. Do u have any idea on this?
> 
I guess what we need is to call mmc_gpio_get_cd() trying to know card's
presence before sending MMC_SEND_STATUS command.  sdhci-esdhc-imx
driver will surely need some changes to cope with that.

Shawn

