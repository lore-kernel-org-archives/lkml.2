Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1GSMwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 08:52:43 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:11869
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751199Ab1GSMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 08:52:42 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz936eK1432N98dK4015Lzz1202hzz8275dhz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 19 Jul 2011 20:59:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: Re: [PATCH] gpio/mxc/mxs: fix build error introduced by the reanming
 of irq_gc_ack()
Message-ID: <20110719125917.GK3838@S2100-06.ap.freescale.net>
References: <1311046444-25423-1-git-send-email-shawn.guo@linaro.org>
 <4E257ACD.6080608@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E257ACD.6080608@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 04:38:37PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 19-07-2011 7:34, Shawn Guo wrote:
> 
> >The following commit renames irq_gc_ack() to irq_gc_ack_set_bit(),
> >and makes gpio-mxc and gpio-mxs fail to build.
> 
> >   659fb32d1b67476f4ade25e9ea0e2642a5b9c4b5
> >   genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)
> 
> >Signed-off-by: Shawn Guo<shawn.guo@linaro.org>
> >---
> >The build error is being seen on linux-next.
> 
> >  drivers/gpio/gpio-mxc.c |    2 +-
> >  drivers/gpio/gpio-mxs.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> >diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
> >index 89fda58..4a46fbe 100644
> >--- a/drivers/gpio/gpio-mxc.c
> >+++ b/drivers/gpio/gpio-mxc.c
> >@@ -297,7 +297,7 @@ static void __init mxc_gpio_init_gc(struct mxc_gpio_port *port)
> >  	gc->private = port;
> >
> >  	ct = gc->chip_types;
> >-	ct->chip.irq_ack = irq_gc_ack,
> >+	ct->chip.irq_ack = irq_gc_ack_set_bit,
> 
>    There should be semicolon rathern than comma at the end.
> 
Thanks, Sergei.  I'm pretty surprised that gcc did not help me there.

Regards,
Shawn

> >  	ct->chip.irq_mask = irq_gc_mask_clr_bit;
> >  	ct->chip.irq_unmask = irq_gc_mask_set_bit;
> >  	ct->chip.irq_set_type = gpio_set_irq_type;
> >diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> >index d8cafba..88f8506 100644
> >--- a/drivers/gpio/gpio-mxs.c
> >+++ b/drivers/gpio/gpio-mxs.c
> >@@ -156,7 +156,7 @@ static void __init mxs_gpio_init_gc(struct mxs_gpio_port *port)
> >  	gc->private = port;
> >
> >  	ct = gc->chip_types;
> >-	ct->chip.irq_ack = irq_gc_ack,
> >+	ct->chip.irq_ack = irq_gc_ack_set_bit,
> 
>    Same here.
> 
> WBR, Sergei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

