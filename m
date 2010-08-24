Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0HXJdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:33:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32930 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0HXJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lWVP4vA6mfxdqEWidF/T2BtqHqKwKJ/1VOK9Uy2yn38/iZXC+UmqmNSmFbOspHNoQf
         dxPWj/xj/IdtYp8my8Y6H8n4qaxO04oDHERGk+WfhQAtBiyfXxu8j/qRKNCKg2aVFIjO
         H/OKFagKqIJgrzrbaCtFmB9Xru7ATodMLofDY=
Date: Tue, 24 Aug 2010 13:33:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: Fix HAVE_GPIO_LIB leftovers in asm-generic/gpio.h
Message-ID: <20100824093315.GA30102@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7444a72effa632fcd8edc566f88 ("gpiolib: allow user-selection")
removed HAVE_GPIO_LIB Kconfig symbol, but the header file still uses
the name [to confuse readers wrt #ifdef/#else/#endif location].

The real Kconfig symbol nowadays is CONFIG_GPIOLIB.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 include/asm-generic/gpio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index c7376bf..d98e281 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -198,7 +198,7 @@ extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
-#else	/* !CONFIG_HAVE_GPIO_LIB */
+#else	/* !CONFIG_GPIOLIB */
 
 static inline int gpio_is_valid(int number)
 {
@@ -227,7 +227,7 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	gpio_set_value(gpio, value);
 }
 
-#endif /* !CONFIG_HAVE_GPIO_LIB */
+#endif /* !CONFIG_GPIOLIB */
 
 #ifndef CONFIG_GPIO_SYSFS
 
-- 
1.7.0.5
