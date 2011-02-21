Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1BUJhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 04:37:23 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:59633 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1BUJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 04:37:22 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Date: Mon, 21 Feb 2011 10:37:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, Eric Miao <eric.y.miao@gmail.com>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <201102211009.31381.alexander.stein@systec-electronic.com> <20110221091916.GA2616@pengutronix.de>
In-Reply-To: <20110221091916.GA2616@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102211037.19572.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, 10:19:16 Wolfram Sang wrote:
> > > Sharing GPIOs in read-only mode, is indeed something that is not
> > > covered by the GPIO API. It might be worth adding a
> > > gpio_request_shared, which would only permit setting the direction to
> > > input. Futher gpio_request_shared calls would be allowed but
> > > gpio_request calls would fail.
> > 
> > gpio_request_shared sounds interesting, but in this case an implicit
> 
> Can you name a use-case? One reason is that we won't need to implement
> it if there is no user, another one is that it could potentially weaken
> abstractions?

We had exported our 5V_enable gpio to sysfs to allow a user-space application 
to enable/disable devices connected to 5V circuit.
But on the other hand we had to read the current status of this gpio in the 
power-fail interrupt handler to distinguish between false-positive (5V 
disabled) and a correct detection.
As the sysfs export requests the gpio we cannot gpio_request it in the power-
fail driver and just used gpio_get_value without request.
We set the direction already in the machine startup code and never touched it 
again.

Alexander
