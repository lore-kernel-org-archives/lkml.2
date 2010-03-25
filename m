Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0CYTmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:42:22 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:57384 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0CYTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:42:20 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 15:42:20 EDT
Date: Thu, 25 Mar 2010 15:36:04 -0400 (EDT)
From: =?utf-8?Q?J=C3=A9r=C3=B4me_Oufella?= 
	<jerome.oufella@savoirfairelinux.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Message-ID: <566941124.2751269545764521.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <1226966206.2731269545548579.JavaMail.root@mail.savoirfairelinux.com>
Subject: gpiolib: irq functions not implemented on x86
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 5.0.19_GA_2995.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.19_GA_2995.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a gpiolib implementation for Technologic Systems TS-5500 boards (x86)
custom GPIO lines. Some of their GPIO lines are directly hooked to CPU (ElanSC520)
GPIRQ lines, so they can trigger IRQs.

However, looking at arch/x86/include/asm/gpio.h:
/*
 * Not implemented, yet.
 */
static inline int gpio_to_irq(unsigned int gpio)
{
        return -ENOSYS;
}

gpio_to_irq()/irq_to_gpio() are not defined on x86 yet.

Q: Is there a reason not to have it call gpiolib's __gpio_to_irq(), as done 
for other gpiolib functions defined here ? such as

-       return -ENOSYS;
+       return __gpio_to_irq(gpio);


Thanks
Jerome Oufella
