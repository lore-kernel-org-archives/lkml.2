Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab2AKTQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:16:24 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40121 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab2AKTQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:16:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>
Subject: [PATCH] gpio/it8761e: Restrict it8761e gpio driver to x86.
Date: Wed, 11 Jan 2012 12:16:11 -0700
Message-Id: <1326309371-10757-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does an unconditional read of io space during module init which
causes a bad dereference on ARM.  It looks to me like this is an x86 only
drivers, so restrict it to only compile on x86.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 37c4bd1..76146b5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -87,6 +87,7 @@ config GPIO_GENERIC_PLATFORM
 
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
+	depends on X86
 	help
 	  Say yes here to support GPIO functionality of IT8761E super I/O chip.
 
-- 
1.7.5.4

