Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2CET1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:27:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33507 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2CET1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:27:52 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+mdqwEZs6Ku3XRfLry1UhE
Date: Mon, 5 Mar 2012 11:27:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] ARM: OMAP1: ams-delta: set up regulator over
 modem reset GPIO pin
Message-ID: <20120305192742.GK12083@atomide.com>
References: <1330963512-20413-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <1330963512-20413-2-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330963512-20413-2-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [120305 07:35]:
> The Amstrad Delta on-board latch2 bit named MODEM_NRESET, now available
> as a GPIO pin AMS_DELTA_GPIO_PIN_NMODEM_RESET, is used to power up/down
> (bring into/out of a reset state) two distinct on-board devices
> simultaneously: the modem, and the voice codec. As a consequence, that
> bit is, or can be, manipulated concurrently by two drivers, or their
> platform provided hooks.
> 
> Instead of updating those drivers to use the gpiolib API as a new method
> of controlling the MODEM_NRESET pin state, like it was done to other
> drivers accessing latch2 pins, and still being vulnerable to potential
> concurrency conflicts, or trying to solve that sharing issue with a
> custom piece of code, set up a fixed regulator device on top of that
> GPIO pin, with the intention of updating both drivers to manipulate that
> regulator, not the GPIO pin directly.
> 
> Before the ASoC driver is updated and the modem platform data expanded
> with a power management callback for switching its power, the
> ams_delta_latch_write() function, which still provides the old API for
> accessing latch2 functionality from not updated drivers, is modified to
> toggle the regulator instead of the MODEM_NRESET GPIO pin.  A helper
> function provided for balancing the regulator enable/disable operations,
> together with the consumer data needed for tracking the regulator state,
> will be removed once the drivers are updated.
> 
> Depends on patch series "ARM: OMAP1: ams-delta: replace custom I/O with
> GPIO".
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> v2 -> v3 changes:
> * fix section mismatch isue.
> 
> Changes against initial version:
> * rename consumer setup elements to match their final, modem only
>   related purpose,
> * initialize the regulator pointer and mutex before first use, then
>   omit testing that pointer against NULL value

Thanks, applying all three into ams-delta branch.

Regards,

Tony
