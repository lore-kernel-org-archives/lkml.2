Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2GIUbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:31:16 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59202 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab2GIUbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 9 Jul 2012 22:31:14 +0200
Message-ID: <CACRpkdZ=6yP58DvY287h9tL1pL_oQk8JfjvYJhc80==yvzz=TA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 1:22 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Since users must be explicitly provided with a GPIO number in order to
> request one the overwhelmingly common case for failing to request will
> be that the required GPIO driver has not yet registered and we should
> therefore defer until it has registered.
>
> In order to avoid having to code this logic in individual drivers have
> gpio_request() return -EPROBE_DEFER when failing to look up the GPIO.
> Drivers which don't want this behaviour can override it if they desire.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

While this makes perfect sense to me I would *really* like to
wait for Grants opinion on this one patch, him having devised
the deferral and being GPIO maintainer.

Is any deferral of this deferral mechanism causing you to
defer important work right now?

Yours,
Linus Walleij
