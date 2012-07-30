Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2G3PGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:06:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51384 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3PGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:06:47 -0400
From: Colin Ian King <colin.king@canonical.com>
To: Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH] USB: echi-dbgp: increase the controller wait time to come out of halt.
Date: Mon, 30 Jul 2012 16:06:42 +0100
Message-Id: <1343660802-10391-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default 10 microsecond delay for the controller to come out of
halt in dbgp_ehci_startup is too short, so increase it to 1 millisecond.

This is based on emperical testing on various USB debug ports on
modern machines such as a Lenovo X220i and an Ivybridge development
platform that needed to wait ~450-950 microseconds.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index ee0ebac..89dcf15 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -450,7 +450,7 @@ static int dbgp_ehci_startup(void)
 	writel(FLAG_CF, &ehci_regs->configured_flag);
 
 	/* Wait until the controller is no longer halted */
-	loop = 10;
+	loop = 1000;
 	do {
 		status = readl(&ehci_regs->status);
 		if (!(status & STS_HALT))
-- 
1.7.10.4

