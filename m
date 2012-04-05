Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab2DEWxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:53:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2DEWxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:53:00 -0400
Date: Thu, 5 Apr 2012 15:52:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, <rpurdie@rpsys.net>,
        <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH] LEDS: LED module for DA9052/53 PMIC v2
Message-Id: <20120405155258.6af697f3.akpm@linux-foundation.org>
In-Reply-To: <1329916149.24042.7.camel@dhruva>
References: <1329916149.24042.7.camel@dhruva>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012 18:39:09 +0530
Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:

> LED Driver for Dialog Semiconductor DA9052/53 PMICs.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>

This email was cc'ed to Dajun.Chen@diasemi.com.  I'll assume that both
work correctly.

>  drivers/leds/Kconfig       |    8 ++
>  drivers/leds/Makefile      |    1 +
>  drivers/leds/leds-da9052.c |  214 ++++++++++++++++++++++++++++++++++++++++++++

Looks OK.  I added one little fixup:

--- a/drivers/leds/leds-da9052.c~leds-led-module-for-da9052-53-pmic-v2-fix
+++ a/drivers/leds/leds-da9052.c
@@ -40,7 +40,7 @@ struct da9052_led {
 	int brightness;
 };
 
-unsigned char led_reg[] = {
+static unsigned char led_reg[] = {
 	DA9052_LED_CONT_4_REG,
 	DA9052_LED_CONT_5_REG,
 };

This array could actually be made static within da9052_set_led_brightness().
