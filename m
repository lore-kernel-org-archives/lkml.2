Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1BATsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:48:11 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:22272 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1BATsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:48:08 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1296589687!12437251!2
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joachim Eastwood <manabian@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "riku.voipio@iki.fi" <riku.voipio@iki.fi>
CC: "joachim.eastwood@jotron.com" <joachim.eastwood@jotron.com>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>
Date: Tue, 1 Feb 2011 13:48:05 -0600
Subject: RE: [PATCH] leds-pca9532: Add gpio capability v3
Thread-Topic: [PATCH] leds-pca9532: Add gpio capability v3
Thread-Index: AcvCR/R86j6FWbl6T/2eQfQVkNxfNgAAL4/g
Message-ID: <0D753D10438DA54287A00B027084269764CEF59546@AUSP01VMBX24.collaborationhost.net>
References: <AANLkTikqeq_fLSEvVc34Wum1nrf6BojyUp=JAe7m8Lby@mail.gmail.com>
In-Reply-To: <AANLkTikqeq_fLSEvVc34Wum1nrf6BojyUp=JAe7m8Lby@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 01, 2011 12:41 PM, Joachim Eastwood wrote:
> Hello,
> 
> The patch below allows unused leds on pca9532 to be used as gpio. The
> board I am working on now has no less than 6 pca9532 chips. One chips
> is used for only leds, one has 14 leds and 2 gpio and the rest of the
> chips are gpio only.
> 
> There is also one board in mainline which could use this capabilty;
> arch/arm/mach-iop32x/n2100.c
>  232         {       .type = PCA9532_TYPE_NONE }, /* power OFF gpio */
>  233         {       .type = PCA9532_TYPE_NONE }, /* reset gpio */
> 
> This patch defines a new pin type, PCA9532_TYPE_GPIO, and registers a
> gpiochip if any pin has this type set. The gpio will registers all
> chip pins but will filter on gpio_request.
> 
> Changes in v3:
> * Fixed direction_output funtion, thanks to H Hartley Sweeten
> * direction_input now calles set_value as direction_output
> * Instructions in Kconfig
> 
> Tested on custom ARM board.
> 
> -------------------------------------------------------------------
>     [leds-pca9532] Add gpio capability
> 
>     Pins not used for leds can now be used as gpio by setting pin type as
>     PCA9532_TYPE_GPIO and defining a gpio_base in platform data.
> 
>     Signed-off-by: Joachim Eastwood <joachim.eastwood@jotron.com>
>     Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

Looks good.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
