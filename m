Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1BULHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:07:32 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:35333 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1BULHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:07:31 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Date: Mon, 21 Feb 2011 12:07:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, Eric Miao <eric.y.miao@gmail.com>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <201102211037.19572.alexander.stein@systec-electronic.com> <20110221094756.GC2616@pengutronix.de>
In-Reply-To: <20110221094756.GC2616@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102211207.29291.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011, 10:47:56 Wolfram Sang wrote:
> > We had exported our 5V_enable gpio to sysfs to allow a user-space
> > application to enable/disable devices connected to 5V circuit.
> > But on the other hand we had to read the current status of this gpio in
> > the power-fail interrupt handler to distinguish between false-positive
> > (5V disabled) and a correct detection.
> 
> What about gpio_export() (description in Documentation/gpio.txt)?

Ah, I didn't know about this. I just expected this is only used from sysfs 
part. But you have to make sure your .ko is loaded before userspace is 
accessing sysfs and tries to export the GPIO.
Or is it "allowed" by the API convention to gpio_request and gpio_export (and 
set direction) a GPIO in the machine startup code which will later be used in 
a different place?

Alexander
