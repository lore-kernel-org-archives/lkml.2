Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2FYTOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:14:00 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39516 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2FYTN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340454566-7206-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 26 Jun 2012 03:13:58 +0800
Message-ID: <CACRpkdbKyHtwcsGoph_s-YPtn9yUxxKQBfXc_ksiNu=yE51spA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add support for Wolfson Microelectronics Arizona
 class devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 8:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

I'm uncertain when it comes to the semantics of these babies,
and can't really tell what's going on:

> +       return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
> +                                 ARIZONA_GPN_DIR, ARIZONA_GPN_DIR);
(...)
> +       return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
> +                                 ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
(...)
> +       regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
> +                          ARIZONA_GPN_LVL, value);

I'm guessing that regmap is caching, selectively updating volatile
regs and marshalling the writes in the background.

The rest looks simple and flawless, and of course I trust that you're
doing the right thing with regmap anyway so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
