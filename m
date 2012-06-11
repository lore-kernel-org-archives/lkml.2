Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2FKUhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 16:37:18 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46604 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2FKUhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 16:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-10-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-10-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 22:37:14 +0200
Message-ID: <CACRpkdaMDbH4NkiHRLAfbJZ_j4QXbwg94bvaWsdYRPH+dSfc8Q@mail.gmail.com>
Subject: Re: [PATCH 09/14] i2c: Add Device Tree support to the Nomadik I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> As new users are
> added, it is expected that they will be Device Tree compliant.
> If this is the case, we will look up their initialisation values
> by compatible entry, then apply them forthwith.
(...)
> +static struct nmk_i2c_controller u8500_i2c = {
> +       /*
> +        * slave data setup time, which is
> +        * 250 ns,100ns,10ns which is 14,6,2
> +        * respectively for a 48 Mhz
> +        * i2c clock
> +        */
> +       .slsu           = 0xe,
> +       /* Tx FIFO threshold */
> +       .tft            = 1,
> +       /* Rx FIFO threshold */
> +       .rft            = 8,
> +       /* std. mode operation */
> +       .clk_freq       = 100000,
> +       /* Slave response timeout(ms) */
> +       .timeout        = 200,
> +       .sm             = I2C_FREQ_MODE_FAST,
> +};

So why don't we create proper device tree bindings for the above platform
data?

For example several driver under
Documentation/devicetree/bindings/i2c/*
define the .clk_freq above as "clock-frequency"

samsung-i2c even has this:
samsung,i2c-sda-delay = <100>;
samsung,i2c-max-bus-freq = <100000>;

Where i2c-sda-delay corresponds to slsu above.

I suspect .sm can be derived from the frequency so it
is "FAST" whenever the frequency > 100000.

This looks to me like a way to push the burden of doing the real
device tree binding for the above to the next user.
(Which will likely be me, so therefore I care a bit ...)

Yours,
Linus Walleij
