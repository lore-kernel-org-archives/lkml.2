Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1GDGsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 02:48:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34675 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1GDGsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 02:48:47 -0400
Date: Mon, 4 Jul 2011 00:48:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add missing intialisation of bgc->dir
Message-ID: <20110704064844.GM15152@ponder.secretlab.ca>
References: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
 <1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1309522131-2237-2-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:08:51PM +0200, Lothar Waßmann wrote:
> ---
>  drivers/gpio/basic_mmio_gpio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index 8152e9f..e69a453 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -399,6 +399,7 @@ int __devinit bgpio_init(struct bgpio_chip *bgc,
>  		return ret;
>  
>  	bgc->data = bgc->read_reg(bgc->reg_dat);
> +	bgc->dir = bgc->read_reg(bgc->reg_dir);

Hi Lothar.

You'll need to double check your email setup.  The patch got emailed
separately from the description.

I don't know if this is a valid thing to do or not.  Not every GPIO
controller supports reading back the initial state from the direction
register.  I suspect it is better to leave initialization of the
direction to the gpio controller driver itself.

g.

