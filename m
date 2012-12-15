Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2LOKwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:52:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60351 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2LOKwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:52:17 -0500
Date: Sat, 15 Dec 2012 10:51:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, rmallon@gmail.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca, daniel-gl@gmx.net,
        sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
Message-ID: <20121215105157.GN14363@n2100.arm.linux.org.uk>
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CBBB25.20002@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 12:49:57AM +0100, Roland Stigge wrote:
> Without having an AT91 available right now, I guess the hardware
> interface of this GPIO chip is different from the GPIO block API. While
> the hardware has clear and set registers, the val parameter of
> at91_gpiolib_set_block() should be interpreted as the actual output
> values. See lpc32xx_gpo_set_block() for an example for handling set and
> clear registers like this: First, set_bits and clear_bits words are
> calculated from mask and val parameters, and finally written to the
> respective hardware registers.
> 
> Note that one .set_block() can result in writing both the set and clear
> registers of the hardware when val contains both 0s and 1s in
> respectively masked positions.

Note also that if this is the same IP as found in SAM3N devices, that it's
possible to write the bit values directly through the OWER/OWDR (output
write enable register/disable register) plus the ODSR (output data status
register) which will synchronously change the state of all the
write-enabled output pins.  That may be important for some applications.
