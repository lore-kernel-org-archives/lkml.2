Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1BUJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:09:36 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:38683 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1BUJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:09:34 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Date: Mon, 21 Feb 2011 10:09:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <201102171321.47704.alexander.stein@systec-electronic.com> <4D5D1D3E.2020107@metafoo.de>
In-Reply-To: <4D5D1D3E.2020107@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102211009.31381.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, 14:06:06 Lars-Peter Clausen wrote:
> > Well, ownership is a bit misleading here. You must request a GPIO to
> > change its direction. But to set or get a value this isn't required.
> 
> Well, it is not enforced in the actual code, but the GPIO API is based on
> convention and I would consider it a misusage of the API to call
> gpio_{set,get}_value without requesting the pin and having configured its
> direction prior to it.
> 
> > In general one could expect if you requested a GPIO you are the only one
> > to call any function on it. On the other hand, this may be bad in some
> > situations where you want to read a GPIO value from different places.
> 
> Sharing GPIOs in read-only mode, is indeed something that is not covered by
> the GPIO API. It might be worth adding a gpio_request_shared, which would
> only permit setting the direction to input. Futher gpio_request_shared
> calls would be allowed but gpio_request calls would fail.

gpio_request_shared sounds interesting, but in this case an implicit 
gpio_direction_input call has to be done in the first shared request. But the 
user must/should not call gpio_direction_input himself which is quite a bit 
different than using a normal gpio_requested gpio.

Alexander
