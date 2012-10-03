Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab2JCTJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:09:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40951 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2JCTI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:08:58 -0400
Date: Wed, 3 Oct 2012 20:08:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
Message-ID: <20121003190855.GA1275@sirena.org.uk>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348780923-27428-1-git-send-email-stigge@antcom.de>
X-Cookie: Do I have a lifestyle yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:22:02PM +0200, Roland Stigge wrote:

> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.

> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs in the same gpio_chip (bit mapped). Further, it adds a
> sysfs interface (/sys/class/gpio/gpiochipXX/block).

It would be very useful if this had the option of falling back to
addressing the GPIOs one by one.  There's some usages that aren't
performance dependent and it'd make drivers able to run even if they're
suboptimal.
