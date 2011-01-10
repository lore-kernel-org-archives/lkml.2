Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1AJW2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:28:15 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754711Ab1AJW2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:28:13 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX182ZJVhVqA2FNajp9J2ACi/cQ1y/DIpJPgoV3BOQd
	DwKANfLA0sLObg
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Charles Clement <caratorn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/vt6655: fix sparse warning "obsolete struct initializer"
Date: Mon, 10 Jan 2011 23:28:06 +0100
Message-Id: <1294698486-23814-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sparse warnings
"obsolete struct initializer, use C99 syntax" in vt6655/device_main.c
by converting the struct to C99 syntax

KernelVersion: linux-next-20110110

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/vt6655/device_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f5028d9..4fbacf8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -312,9 +312,9 @@ static int device_notify_reboot(struct notifier_block *, unsigned long event, vo
 static int viawget_suspend(struct pci_dev *pcid, pm_message_t state);
 static int viawget_resume(struct pci_dev *pcid);
 struct notifier_block device_notifier = {
-        notifier_call:  device_notify_reboot,
-        next:           NULL,
-        priority:       0
+	.notifier_call = device_notify_reboot,
+	.next = NULL,
+	.priority = 0,
 };
 #endif
 
@@ -3606,13 +3606,13 @@ static int ethtool_ioctl(struct net_device *dev, void *useraddr)
 MODULE_DEVICE_TABLE(pci, vt6655_pci_id_table);
 
 static struct pci_driver device_driver = {
-        name:       DEVICE_NAME,
-        id_table:   vt6655_pci_id_table,
-        probe:      vt6655_probe,
-        remove:     vt6655_remove,
+	.name = DEVICE_NAME,
+	.id_table = vt6655_pci_id_table,
+	.probe = vt6655_probe,
+	.remove = vt6655_remove,
 #ifdef CONFIG_PM
-        suspend:    viawget_suspend,
-        resume:     viawget_resume,
+	.suspend = viawget_suspend,
+	.resume = viawget_resume,
 #endif
 };
 
-- 
1.7.2.2

