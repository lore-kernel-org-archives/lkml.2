Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2LQNch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:32:37 -0500
Received: from antcom.de ([188.40.178.216]:34877 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LQNcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:32:36 -0500
Message-ID: <50CF1EF1.2070601@antcom.de>
Date: Mon, 17 Dec 2012 14:32:33 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: rmallon@gmail.com, gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, grant.likely@secretlab.ca, daniel-gl@gmx.net,
        sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com>
In-Reply-To: <50CF0744.7040404@grandegger.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 12:51 PM, Wolfgang Grandegger wrote:
>>> Without having an AT91 available right now, I guess the hardware
>>> interface of this GPIO chip is different from the GPIO block API. While
>>> the hardware has clear and set registers, the val parameter of
>>> at91_gpiolib_set_block() should be interpreted as the actual output
>>> values. See lpc32xx_gpo_set_block() for an example for handling set and
>>> clear registers like this: First, set_bits and clear_bits words are
>>> calculated from mask and val parameters, and finally written to the
>>> respective hardware registers.
>>>
>>> Note that one .set_block() can result in writing both the set and clear
>>> registers of the hardware when val contains both 0s and 1s in
>>> respectively masked positions.
>>
>> Oops, I obviously did not test GPIO block write. The patch below does
>> work now. Feel free to add it to the next version of your series.
> 
> The patch lacks an important fix, sorry. Please consider the updated
> patch below.

Thanks!

And I guess Russell is right: If possible, we should write outputs
simultaneously via ODSR (plus OWER/OWDR/OWSR) instead of separate set/clear.

I wonder if we need to save/restore the state of OWSR at every write
operation or if we need/can cache it. Assuming that block GPIO are the
only code in the kernel that manipulates ODSR.

Further: Can we include this patch for arch/arm/mach-at91 via the gpio
subsystem or does it need to go separately via arm-soc.git?

Thanks,

Roland
