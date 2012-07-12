Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab2GLIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:43:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5920 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2GLInm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:43:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Jul 2012 01:39:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <swarren@nvidia.com>,
        <vbyravarasu@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] usb: host: tegra: pass correct pointer in ehci_setup()
Date: Thu, 12 Jul 2012 14:06:48 +0530
Message-ID: <1342082208-14184-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehci_setup() require the pointer of usb_hcd.
Passing the correct pointer in place of ehci_hcd
pointer.

This is side effetct of change:
commit 1a49e2ac9651df7349867a5cf44e2c83de1046af
Author: Alan Stern <stern@rowland.harvard.edu>

    EHCI: centralize controller initialization


Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 9e44b1f..d2a7c95 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -285,7 +285,7 @@ static int tegra_ehci_setup(struct usb_hcd *hcd)
 	/* switch to host mode */
 	hcd->has_tt = 1;
 
-	retval = ehci_setup(ehci);
+	retval = ehci_setup(hcd);
 	if (retval)
 		return retval;
 
-- 
1.7.1.1

