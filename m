Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab2FLLN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:13:27 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46166 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2FLLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206071658530.24700@axis700.grange>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
	<4FBCF9F0.1010901@wwwdotorg.org>
	<Pine.LNX.4.64.1205231659310.21980@axis700.grange>
	<4FBD01A6.4080807@wwwdotorg.org>
	<Pine.LNX.4.64.1206070332100.9501@axis700.grange>
	<CACRpkdbtUbi0_k-uupJ0RT-4c9cVCvnqp_xnUgKCpA8MQtVhsQ@mail.gmail.com>
	<Pine.LNX.4.64.1206071658530.24700@axis700.grange>
Date: Tue, 12 Jun 2012 13:13:25 +0200
Message-ID: <CACRpkdbYCSpxVt0oobv+tVwfgM4=1aDW+bF120BgfAyO565KRw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 5:14 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 7 Jun 2012, Linus Walleij wrote:
>> Isn't the card detection and write protect GPIO lines that
>> will be requested with gpio_request()? This is usually the case,
>> so I need to ask. GPIOs are usually muxed in on a per-pin basis
>> as a result of the gpio_request() call.
>
> They can be, but they don't have to be. On some SDHI implementations CD is
> a dedicated pin, belonging to the controller, but in those cases it is
> usually preferable to configure it as a GPIO. On some boards it is just a
> GPIO, on others yet it is just missing. Similarly, WP can be a GPIO or
> absent.

Sorry just to be clear on what we mean here:

"Configuring it as GPIO" in Linux means that you use the GPIO
subsystem and gpiolib to access it.

If you mean that you set some electrical properties that are named
as "the GPIO configuration" in the datasheet that is something else.

So that you mux it in as "gpio" (a name of the function from the
datasheet) does not make it into a GPIO in the Linux sense if it's not
handled by gpiolib.

In the case where such a pin is used by e.g. the MMC driver while
put into what the datasheet calls "gpio mode" this is still just one
pin in the MMC pinctrl function from the Linux point of view.

But I guess this was what you meant all the time, I'm probably just
confused by names being the same for similar but unrelated
things ... :-)

Yours,
Linus Walleij
