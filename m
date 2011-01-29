Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1A2Uig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 15:38:36 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:45720 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1A2Uif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 15:38:35 -0500
Date: Sat, 29 Jan 2011 21:38:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hemanth V <hemanthv@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [RFC] add pwmlib support
Message-ID: <20110129213821.0e51dc32@endymion.delvare>
In-Reply-To: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
References: <1296217283-14531-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Fri, 28 Jan 2011 13:21:21 +0100, Sascha Hauer wrote:
> While implementing just another pwm driver I thought it's time to implement
> generic pwm support. The following series adds drivers/pwm/pwmlib.c and
> a i.MX23/28 pwm driver which serves as a usage example for pwmlib. The
> code is inspired by gpiolib support and tested using the backlight pwm
> driver by Eric Miao.
> 
> Currently the pwm_request, pwm_add, pwm_remove and pwm_free operations are
> protected with a single mutex wherea the pwm_enable, pwm_disable and
> pwm_config operations are unlocked. It is assumed that the owners of the
> pwm handle the serialization of the pwm accesses. This may not be enough, so
> i'd like to discuss the locking (and type of locking) here.
> 
> I Cced the people working with PWMs in the kernel in the hope that they can
> give input on what's missing / wrong in this implementation

I do not have the time to review your patches. But I think your
introduction above lacks a fundamental point, which is: what are you
trying to achieve? What would you be able to do with pwmlib, which you
currently aren't?

As far as hwmon driver are concerned, please understand that "PWM" is a
misnomer for "fan speed control". Some hwmon drivers have pwm
attributes which actually correspond to analog voltage outputs. In both
cases (PWM and DC) these are outputs which are dedicated to fan
control, and I've never seen any other use of these, so I doubt it
would make much sense to register them as generic pwm outputs.

So I believe that hwmon drivers are out of scope for pwmlib. Which
makes me wonder what you intend to do with pwmlib (back to my first
question...) as the only use I know of for PWM signals in computers is
for fan control.

-- 
Jean Delvare
