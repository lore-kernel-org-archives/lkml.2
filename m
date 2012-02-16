Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2BPTQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:16:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51579 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2BPTQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:16:37 -0500
MIME-Version: 1.0
In-Reply-To: <5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
References: <cover.1329396583.git.rubini@gnudd.com>
	<5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
Date: Thu, 16 Feb 2012 20:16:36 +0100
Message-ID: <CACRpkdaL=f7A6se63yXO=bwySC_S2yRd4r3AEfTAy6YtGi5-CQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:00 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

> +/*
> + * Special method: alternate functions and pullup/pulldown. This will
> + * need to be exported to other drivers, adding a way to retrieve
> + * the gsta_gpio structure from their own pci device
> + */
> +void gsta_set_config(struct gsta_gpio *chip, int nr, unsigned cfg)
> +{
(...)
> +       if (cfg == PINMUX_TYPE_NONE)
(...)
> +       if (cfg == PINMUX_TYPE_FUNCTION)
(...)
> +       if (cfg == PINMUX_TYPE_FUNCTION) {
(...)
> +       case PINMUX_TYPE_OUTPUT_LOW:
(...)
> +       case PINMUX_TYPE_OUTPUT_HIGH:
(...)
> +       case PINMUX_TYPE_INPUT:
(...)
> +       case PINMUX_TYPE_INPUT_PULLUP:
(...)
> +       case PINMUX_TYPE_INPUT_PULLDOWN:

We have created the pin control subsystem to handle things like
this. (Muxing and complex control.)

Please create a driver in drivers/pinctrl/pinctrl-sta2x11.c that
expose both a pinctrl and a GPIOlib interface. The GPIOlib
interface can call into the pin control portions just fine.

We've had some refactoring in the pin control subsystem recently
so check linux-next for the latest API. The documentation in
Documentation/pinctrl.txt should be pretty uptodate, else
tell me!

I'm giving a talk about pin control at ELC tomorrow, mail
me if you want a copy of the slides!

Yours,
Linus Walleij
