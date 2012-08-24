Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab2HXSjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:39:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54029 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2HXSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:39:01 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH drm-next] drm: udl: usb: Fix recursive Kconfig dependency
Date: Fri, 24 Aug 2012 20:38:42 +0200
Message-Id: <1345833522-16618-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/usb/Kconfig "config USB_ARCH_HAS_HCD" is within "if USB_SUPPORT"
statement.

In drivers/gpu/drm/Kconfig "config DRM_USB" depends on USB_ARCH_HAS_HCD
but selects USB_SUPPORT which leads to the error for udl Kconfig:

$ yes "" | make oldconfig
scripts/kconfig/conf --oldconfig Kconfig
drivers/gpu/drm/udl/Kconfig:1:error: recursive dependency detected!
drivers/gpu/drm/udl/Kconfig:1:  symbol DRM_UDL depends on USB_ARCH_HAS_HCD
drivers/usb/Kconfig:76: symbol USB_ARCH_HAS_HCD depends on USB_SUPPORT
drivers/usb/Kconfig:58: symbol USB_SUPPORT is selected by DRM_USB
drivers/gpu/drm/Kconfig:22:     symbol DRM_USB is selected by DRM_UDL

Fix the issue by dropping "select USB_SUPPORT" from "config DRM_USB".

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/gpu/drm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 3a8c683..90e2808 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -24,7 +24,6 @@ config DRM_USB
 	depends on DRM
 	depends on USB_ARCH_HAS_HCD
 	select USB
-	select USB_SUPPORT
 
 config DRM_KMS_HELPER
 	tristate
-- 
1.7.9.5

