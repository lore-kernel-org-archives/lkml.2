Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab0JSGpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:45:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48151 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0JSGpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:45:46 -0400
Date: Tue, 19 Oct 2010 08:45:43 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <dvrabel@arcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH 1/7] [AVR32] don't check platform_get_irq's return
	value against zero
Message-ID: <20101019064543.GA23839@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 05:10:03PM +0100, Uwe Kleine-König wrote:
> platform_get_irq returns -ENXIO on failure, so !int_irq was probably
> always true.  Better use (int)int_irq <= 0.  Note that a return value of
> zero is still handled as error even though this could mean irq0.
> 
> This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
> changed the return value of platform_get_irq from 0 to -ENXIO on error.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: David Vrabel <dvrabel@arcom.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  arch/avr32/mach-at32ap/extint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
> index 310477b..033f693 100644
> --- a/arch/avr32/mach-at32ap/extint.c
> +++ b/arch/avr32/mach-at32ap/extint.c
> @@ -198,7 +198,7 @@ static int __init eic_probe(struct platform_device *pdev)
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	int_irq = platform_get_irq(pdev, 0);
> -	if (!regs || !int_irq) {
> +	if (!regs || (int)int_irq <= 0) {
>  		dev_dbg(&pdev->dev, "missing regs and/or irq resource\n");
>  		return -ENXIO;
>  	}
ping

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
