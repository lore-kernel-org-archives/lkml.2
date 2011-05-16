Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1EPJIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:08:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:39440 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1EPJIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:08:16 -0400
Date: Mon, 16 May 2011 11:08:13 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Drake <dsd@laptop.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH 07/11] x86, olpc-xo1-sci: Add GPE handler and ebook
 switch functionality
Message-ID: <20110516090813.GA26487@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
 <1304166750-31125-8-git-send-email-dsd@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304166750-31125-8-git-send-email-dsd@laptop.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Drake | 2011-04-30 13:32:26 [+0100]:

>diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
>index 8fbf961..9de2a00 100644
>--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
>+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
>@@ -104,6 +177,37 @@ static int __devinit setup_sci_interrupt(struct platform_device *pdev)
> 	return r;
> }
> 
>+static int __devinit setup_ec_sci(void)
>+{
>+	int r;
>+
>+	r = gpio_request(OLPC_GPIO_ECSCI, "OLPC-ECSCI");
>+	if (r)
>+		return r;
>+
>+	gpio_direction_input(OLPC_GPIO_ECSCI);
>+
>+	/* Clear pending EC SCI events */
>+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
>+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_POSITIVE_EDGE_STS);

why not use the gpio framework here, i.e. gpio_set_value()?

>+
>+	/* Enable EC SCI events */
>+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_EVENTS_ENABLE);
>+
>+	/* Set the SCI to cause a PME event on group 7 */
>+	cs5535_gpio_setup_event(OLPC_GPIO_ECSCI, 7, 1);
>+
>+	/* And have group 7 also fire the SCI interrupt */
>+	cs5535_gpio_set_irq(7, sci_irq);

What do you do here? Could this be hidden behind a gpio irq_chip or is
this too olpc specific?

Sebastian
