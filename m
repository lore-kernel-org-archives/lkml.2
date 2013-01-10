Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3AJPfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:35:43 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:51759 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3AJPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:35:41 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: select USB_ARCH_HAS_EHCI for MXS
Date: Thu, 10 Jan 2013 16:35:36 +0100
Message-Id: <1357832136-16043-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 09f6ffde introduced a dependency on USB_EHCI_HCD for the chipidea
USB host driver, that in turns depends on USB_ARCH_HAS_EHCI.

If this symbol is not set for MXS, the MXS boards are not able to use the
chipidea driver anymore.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/usb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 4c90b51..640ae6c 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -37,6 +37,7 @@ config USB_ARCH_HAS_EHCI
 	default y if ARCH_W90X900
 	default y if ARCH_AT91
 	default y if ARCH_MXC
+	default y if ARCH_MXS
 	default y if ARCH_OMAP3
 	default y if ARCH_CNS3XXX
 	default y if ARCH_VT8500
-- 
1.7.10.4

