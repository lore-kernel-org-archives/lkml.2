Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1EXX1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:27:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757030Ab1EXX1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:27:17 -0400
Date: Tue, 24 May 2011 16:27:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, grant@secretlab.ca,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: Hook up gpiolib support
Message-Id: <20110524162702.06b4bdb4.akpm@linux-foundation.org>
In-Reply-To: <1305752282-10401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1305752282-10401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 13:58:02 -0700
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> Allow people to use gpiolib on Alpha if they want to, mostly for build
> coverage.  The header is a stright copy of that for Microblaze, which in
> turn was taken from PowerPC.

I got a great pile of build errors.


drivers/gpio/gpiolib.c:69: error: 'ARCH_NR_GPIOS' undeclared here (not in a function)
drivers/gpio/gpiolib.c: In function 'gpio_ensure_requested':
drivers/gpio/gpiolib.c:96: error: dereferencing pointer to incomplete type
drivers/gpio/gpiolib.c:100: error: dereferencing pointer to incomplete type
drivers/gpio/gpiolib.c:108: error: dereferencing pointer to incomplete type
drivers/gpio/gpiolib.c: In function 'gpiochip_find_base':


drivers/gpio/gpiolib.c:783: error: redefinition of 'gpio_export_link'
include/linux/gpio.h:120: note: previous definition of 'gpio_export_link' was here                                                                              drivers/gpio/gpiolib.c:830: error: redefinition of 'gpio_sysfs_set_active_low'
include/linux/gpio.h:128: note: previous definition of 'gpio_sysfs_set_active_low' was here


drivers/gpio/timbgpio.c:49: error: field 'gpio' has incomplete type
drivers/gpio/timbgpio.c: In function 'timbgpio_update_bit':
drivers/gpio/timbgpio.c:57: warning: type defaults to 'int' in declaration of '__mptr'

etc.


This fixed them:

--- a/arch/alpha/Kconfig~alpha-hook-up-gpiolib-support-fix
+++ a/arch/alpha/Kconfig
@@ -52,6 +52,9 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CMOS_UPDATE
         def_bool y
 
+config GENERIC_GPIO
+	def_bool y
+
 config ZONE_DMA
 	bool
 	default y
_

