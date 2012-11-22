Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2KVTKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:10:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34024 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab2KVTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:14 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/4] staging/rtl8187se: Remove the unnecessary initialization of a local variable in r8180_core.c
Date: Thu, 22 Nov 2012 09:05:53 +0900
Message-Id: <1353542753-20986-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: do not initialise statics to 0 or NULL

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ea04eec..ea8dbb1 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -62,7 +62,7 @@ static struct pci_device_id rtl8180_pci_id_tbl[] __devinitdata = {
 };
 
 static char ifname[IFNAMSIZ] = "wlan%d";
-static int hwwep = 0;
+static int hwwep;
 
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, rtl8180_pci_id_tbl);
@@ -201,7 +201,7 @@ static struct net_device_stats *rtl8180_stats(struct net_device *dev);
 void rtl8180_commit(struct net_device *dev);
 void rtl8180_start_tx_beacon(struct net_device *dev);
 
-static struct proc_dir_entry *rtl8180_proc = NULL;
+static struct proc_dir_entry *rtl8180_proc;
 
 static int proc_get_registers(char *page, char **start,
 			  off_t offset, int count,
@@ -3725,7 +3725,7 @@ void GPIOChangeRFWorkItemCallBack(struct work_struct *work)
 	char *argv[3];
 	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
 	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL};
-	static int readf_count = 0;
+	static int readf_count;
 
 	readf_count = (readf_count+1)%0xffff;
 	/* We should turn off LED before polling FF51[4]. */
-- 
1.7.9.5

