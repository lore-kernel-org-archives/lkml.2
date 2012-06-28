Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2F1KhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:37:11 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40490 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1KhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:37:09 -0400
From: Arun Raghavan <arun.raghavan@collabora.co.uk>
To: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Raghavan <arun.raghavan@collabora.co.uk>
Subject: [PATCH] apple-gmux: Correctly depend on apple_bl for building
Date: Thu, 28 Jun 2012 16:06:36 +0530
Message-Id: <1340879796-30262-1-git-send-email-arun.raghavan@collabora.co.uk>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apple_bl_register/unregister() are unconditionally used now, so we need
to make sure that apple_bl is selected appropriately (built-in/module)
if apple-gmux is being built.

Signed-off-by: Arun Raghavan <arun.raghavan@collabora.co.uk>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2a262f5..708f835 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -759,7 +759,7 @@ config SAMSUNG_Q10
 config APPLE_GMUX
 	tristate "Apple Gmux Driver"
 	depends on PNP
-	select BACKLIGHT_CLASS_DEVICE
+	select BACKLIGHT_APPLE
 	---help---
 	  This driver provides support for the gmux device found on many
 	  Apple laptops, which controls the display mux for the hybrid
-- 
1.7.8.6

