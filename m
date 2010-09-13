Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0IMTvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:51:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1898 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab0IMTsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:35 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/25] drivers/net/wireless/ipw2x00: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:53 -0700
Message-Id: <9c135a60c2ed3431ee59c8de0b39414f6c10299a.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c       |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/ipw2x00/libipw_module.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 61915f3..f64103c 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -4261,7 +4261,7 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
 	struct net_device *dev = priv->net_dev;
-	char buffer[] = "00000000";
+	char buffer[sizeof("00000000")];
 	unsigned long len =
 	    (sizeof(buffer) - 1) > count ? count : sizeof(buffer) - 1;
 	unsigned long val;
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 0f25083..75e83c9 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -1486,7 +1486,7 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	struct net_device *dev = priv->net_dev;
-	char buffer[] = "00000000";
+	char buffer[sizeof("00000000")];
 	unsigned long len =
 	    (sizeof(buffer) - 1) > count ? count : sizeof(buffer) - 1;
 	unsigned long val;
diff --git a/drivers/net/wireless/ipw2x00/libipw_module.c b/drivers/net/wireless/ipw2x00/libipw_module.c
index 32dee2c..d0c8a67 100644
--- a/drivers/net/wireless/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/ipw2x00/libipw_module.c
@@ -261,7 +261,7 @@ static int debug_level_proc_open(struct inode *inode, struct file *file)
 static ssize_t debug_level_proc_write(struct file *file,
 		const char __user *buffer, size_t count, loff_t *pos)
 {
-	char buf[] = "0x00000000\n";
+	char buf[sizeof("0x00000000\n")];
 	size_t len = min(sizeof(buf) - 1, count);
 	unsigned long val;
 
-- 
1.7.3.rc1

