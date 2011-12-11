Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1LKUNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:13:05 -0500
Received: from d1.icnet.pl ([212.160.220.21]:48104 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1LKUND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:13:03 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH 01/10] GPIO: gpio-generic: Move initialization up to postcore
Date: Sun, 11 Dec 2011 21:11:59 +0100
Message-Id: <1323634328-856-2-git-send-email-jkrzyszt@tis.icnet.pl>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
To: Grant Likely <grant.likely@secretlab.ca>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow boards with custom memory mapped GPIO ports to set up
and use those port pins while initializing devices from arch init.

Created against linux-3.2-rc5.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/gpio/gpio-generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 4e24436..a6eaf38 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -528,7 +528,7 @@ static int __init bgpio_platform_init(void)
 {
 	return platform_driver_register(&bgpio_driver);
 }
-module_init(bgpio_platform_init);
+postcore_initcall(bgpio_platform_init);
 
 static void __exit bgpio_platform_exit(void)
 {
-- 
1.7.3.4

