Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1AKLVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:21:02 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41890 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1AKLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:21:00 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] gpio: implement x86 gpio_to_irq convert function
To: x86@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Jan 2011 10:55:32 +0000
Message-ID: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alek Du <alek.du@intel.com>

We need this for x86 MID platforms where GPIO interrupts are used. No special
magic is needed so the default 1:1 behaviour will do nicely.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/include/asm/gpio.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)


diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 49dbfdf..91d915a 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -38,12 +38,9 @@ static inline int gpio_cansleep(unsigned int gpio)
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
 static inline int irq_to_gpio(unsigned int irq)

