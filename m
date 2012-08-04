Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2HDWEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 18:04:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46161 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2HDWD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 18:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120730165733.33e3ddfb@notabene.brown>
References: <CACRpkdZnRiZpKuQ6krJFa8TAfmvYYLB-n79ztzaUOV32p6ZY1Q@mail.gmail.com>
	<20120730165733.33e3ddfb@notabene.brown>
Date: Sun, 5 Aug 2012 00:03:59 +0200
Message-ID: <CACRpkdbA_+xFUU9G3S+eBs+ffmGEih-jLY5YXxqpNGdfsk48gw@mail.gmail.com>
Subject: Re: [GIT PULL] GPIO changes for v3.6
From: Linus Walleij <linus.walleij@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 8:57 AM, NeilBrown <neilb@suse.de> wrote:

> it means that if !gpio_is_valid(gpio), the error returned is EPROBE_DEFER
> which isn't right (an invalid gpio number will never become valid).
> If a driver happened to use gpio_request to check the validity of the gpio
> rather than doing it itself, it would defer the probe, rather than assume
> that the GPIO doesn't exist.
>
> I would suggest the following.  Reasonable?

Unless there is a firm regression solved by this we can very well
discuss this until the next merge window.

The solution from Mark looks very much like the method used in
regulators, clocks etc. I bet if we look at the error paths of the
driver doing gpio_is_valid() the majority will be something in the
probe() path just bailing out if that was not supplied, alternatively
shunting in some non-GPIO code.

The more typical problem for
deferring driver to solve will be something like commit
2805b9ab7c836cfbe01e86129983e36205078cb2
where we have to check for -EPROBE_DEFER explicitly
and bail out before doing any gpio_is_valid() checks.

Yours,
Linus Walleij
