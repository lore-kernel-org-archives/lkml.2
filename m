Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2KFXlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:41:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32780 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2KFXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:41:00 -0500
Date: Tue, 06 Nov 2012 18:40:58 -0500 (EST)
Message-Id: <20121106.184058.636480855516538607.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: sparclinux@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: SPARC and OF_GPIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
References: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Mon, 5 Nov 2012 10:53:15 +0100

> Are you aware of any reasons why this conflict would still be necessary?

No reason that I can see, I'll push something like the patch below
via the sparc tree.

> This is not only the case for OF_GPIO but likely also for OF_SPI,
> OF_I2C, OF_IRQ and OF_ADDRESS. Shouldn't those all work even on SPARC
> nowadays?

Those also would need to be tested on an individual basis, but
there are no fundamental problems that I am aware of.

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b6b442b..f0a5391 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -14,6 +14,7 @@ config SPARC
 	default y
 	select OF
 	select OF_PROMTREE
+	select OF_GPIO
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d055cee..f11d8e3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -47,7 +47,7 @@ if GPIOLIB
 
 config OF_GPIO
 	def_bool y
-	depends on OF && !SPARC
+	depends on OF
 
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
