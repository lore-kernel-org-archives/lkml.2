Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0KDJ72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:59:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60125 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab0KDJ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:59:27 -0400
Date: Thu, 4 Nov 2010 10:59:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-pcmcia@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] pcmcia/sa1100: don't put machine specific init
	functions in .init.text
Message-ID: <20101104095920.GB16938@pengutronix.de>
References: <1288863974-20434-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288863974-20434-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> [..]
> diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
> index 945857f..6b22859 100644
> --- a/drivers/pcmcia/sa1100_generic.c
> +++ b/drivers/pcmcia/sa1100_generic.c
> @@ -64,7 +64,7 @@ static int (*sa11x0_pcmcia_hw_init[])(struct device *dev) = {
>  #endif
>  };
>  
> -static int sa11x0_drv_pcmcia_probe(struct platform_device *dev)
> +static int __devinit sa11x0_drv_pcmcia_probe(struct platform_device *dev)
>  {
>  	int i, ret = -ENODEV;
>  
BTW, I wonder why sa11x0_pcmcia_hw_init doesn't need to be annotated
with __devinitdata.  I guess the compiler just put's the array into
sa11x0_drv_pcmcia_probe and so modpost doesn't notice.

If you care I can resend with sa11x0_pcmcia_hw_init being marked, too.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
