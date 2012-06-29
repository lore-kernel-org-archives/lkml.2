Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2F2TAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 15:00:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47236 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab2F2TAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 15:00:21 -0400
From: =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Tomasz=20Mo=C5=84?= <desowin@gmail.com>
Subject: [PATCH 1/1] x86/platform: samsung-laptop: Update Kconfig dependencies.
Date: Fri, 29 Jun 2012 22:59:42 +0200
Message-Id: <1341003582-4481-1-git-send-email-desowin@gmail.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samsung-laptop driver can be compiled if ACPI_VIDEO is either compiled or
exluded. Trying to built-in the samsung-laptop driver when ACPI_VIDEO is
compiled as module results in linking error.

This patch resolves this problem by setting proper dependencies in Kconfig.

Signed-off-by: Tomasz Moń <desowin@gmail.com>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2a262f5..5add45e 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -717,6 +717,7 @@ config XO15_EBOOK
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
 	depends on X86
+	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	depends on RFKILL || RFKILL = n
 	depends on BACKLIGHT_CLASS_DEVICE
 	select LEDS_CLASS
-- 
1.7.10

