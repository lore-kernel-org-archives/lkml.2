Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1BQMkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:40:15 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:56250 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1BQMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:40:13 -0500
X-Greylist: delayed 1102 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Feb 2011 07:40:12 EST
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 1/4] gpiolib: Add "unknown" direction support
Date: Thu, 17 Feb 2011 13:21:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Uwe Kleine-K?nig" <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1297904216-15219-1-git-send-email-ptyser@xes-inc.com> <AANLkTi=yZZgh0v+-_Cw0JudAxxTZuBWeVCEZ-dBtENPw@mail.gmail.com> <4D5D0EAA.9030807@metafoo.de>
In-Reply-To: <4D5D0EAA.9030807@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171321.47704.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011, 13:03:54 Lars-Peter Clausen wrote:
> On 02/17/2011 08:33 AM, Eric Miao wrote:
> > On Thu, Feb 17, 2011 at 8:56 AM, Peter Tyser <ptyser@xes-inc.com> wrote:
> >> Previously, gpiolib would unconditionally flag all GPIO pins as inputs,
> >> regardless of their true state.  This resulted in all GPIO output pins
> >> initially being incorrectly identified as "input" in the GPIO sysfs.
> >> 
> >> Since the direction of GPIOs is not known prior to having their
> >> direction set, instead set the default direction to "unknown" to prevent
> >> user confusion.  A pin with an "unknown" direction can not be written or
> >> read via sysfs; it must first be configured as an input or output before
> >> it can be used.
> > 
> > Hrm... that's why I don't like the original definition of gpio_request()
> > which is vague on the pin configurations.
> 
> Actually it doesn't say anything at all about the current configuration at
> all. Requesting a pin grants you exclusive access to that pin, if it
> succeeds. So it is solely about ownership and not about configuration.

Well, ownership is a bit misleading here. You must request a GPIO to change 
its direction. But to set or get a value this isn't required.
In general one could expect if you requested a GPIO you are the only one to 
call any function on it. On the other hand, this may be bad in some situations 
where you want to read a GPIO value from different places.

Alexander
