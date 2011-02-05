Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab1BEOW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1BEOWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dlWbvgoyxPWLb0VfhM9kRaM2x+cejNrnwiu+QGupX70ledMfbkka5YtlynlUvrtWy+
         8YvyeUVQqjLTHBDBKH3nJkyEaY347x+x6P575yGL0260mzhEdvXRXzwdXiKx+rSBdg0Y
         jW3VHyUtnqTUldGzZpWs48ZlSOnifT+ykTpQs=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 32/52] kstrtox: convert drivers/net/wireless/
Date: Sat,  5 Feb 2011 16:20:35 +0200
Message-Id: <1296915654-7458-32-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c      |   22 ++++++----------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   36 ++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 ++++------
 drivers/net/wireless/libertas/mesh.c        |    7 +++--
 drivers/net/wireless/rtlwifi/base.c         |   15 +++-------
 drivers/net/wireless/wl12xx/debugfs.c       |   15 +++-------
 drivers/net/wireless/wl12xx/main.c          |    6 +---
 7 files changed, 46 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3586c43..f061561 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -49,7 +49,6 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long mask;
 	char buf[32];
 	ssize_t len;
 
@@ -58,10 +57,8 @@ static ssize_t write_file_debug(struct file *file, const char __user *user_buf,
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtoint(buf, 0, &common->debug_mask))
 		return -EINVAL;
-
-	common->debug_mask = mask;
 	return count;
 }
 
@@ -94,7 +91,7 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long mask;
+	u8 mask;
 	char buf[32];
 	ssize_t len;
 
@@ -103,7 +100,7 @@ static ssize_t write_file_tx_chainmask(struct file *file, const char __user *use
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtou8(buf, 0, &mask))
 		return -EINVAL;
 
 	common->tx_chainmask = mask;
@@ -137,7 +134,7 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long mask;
+	u8 mask;
 	char buf[32];
 	ssize_t len;
 
@@ -146,7 +143,7 @@ static ssize_t write_file_rx_chainmask(struct file *file, const char __user *use
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtou8(buf, 0, &mask))
 		return -EINVAL;
 
 	common->rx_chainmask = mask;
@@ -804,7 +801,6 @@ static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
-	unsigned long regidx;
 	char buf[32];
 	ssize_t len;
 
@@ -813,10 +809,8 @@ static ssize_t write_file_regidx(struct file *file, const char __user *user_buf,
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &regidx))
+	if (kstrtou32(buf, 0, &sc->debug.regidx))
 		return -EINVAL;
-
-	sc->debug.regidx = regidx;
 	return count;
 }
 
@@ -847,7 +841,7 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_hw *ah = sc->sc_ah;
-	unsigned long regval;
+	u32 regval;
 	char buf[32];
 	ssize_t len;
 
@@ -856,7 +850,7 @@ static ssize_t write_file_regval(struct file *file, const char __user *user_buf,
 		return -EFAULT;
 
 	buf[len] = '\0';
-	if (strict_strtoul(buf, 0, &regval))
+	if (kstrtou32(buf, 0, &regval))
 		return -EINVAL;
 
 	REG_WRITE_D(ah, sc->debug.regidx, regval);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 36335b1..1d80cb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1463,19 +1463,16 @@ static ssize_t store_debug_level(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret)
+	ret = kstrtou32(buf, 0, &priv->debug_level);
+	if (ret) {
 		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
-	else {
-		priv->debug_level = val;
-		if (iwl_alloc_traffic_mem(priv))
-			IWL_ERR(priv,
-				"Not enough memory to generate traffic log\n");
+		return ret;
 	}
-	return strnlen(buf, count);
+	if (iwl_alloc_traffic_mem(priv))
+		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
+	return count;
 }
 
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
@@ -1514,21 +1511,20 @@ static ssize_t store_tx_power(struct device *d,
 			      const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
+	u8 val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
+	ret = kstrtou8(buf, 10, &val);
+	if (ret) {
 		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
-	else {
-		ret = iwl_set_tx_power(priv, val, false);
-		if (ret)
-			IWL_ERR(priv, "failed setting tx power (0x%d).\n",
-				ret);
-		else
-			ret = count;
+		return ret;
 	}
-	return ret;
+	ret = iwl_set_tx_power(priv, val, false);
+	if (ret) {
+		IWL_ERR(priv, "failed setting tx power (0x%d).\n", ret);
+		return ret;
+	}
+	return count;
 }
 
 static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 371abbf..85a58e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3444,19 +3444,16 @@ static ssize_t store_debug_level(struct device *d,
 				 const char *buf, size_t count)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret)
+	ret = kstrtou32(buf, 0, &priv->debug_level);
+	if (ret) {
 		IWL_INFO(priv, "%s is not in hex or decimal form.\n", buf);
-	else {
-		priv->debug_level = val;
-		if (iwl_alloc_traffic_mem(priv))
-			IWL_ERR(priv,
-				"Not enough memory to generate traffic log\n");
+		return ret;
 	}
-	return strnlen(buf, count);
+	if (iwl_alloc_traffic_mem(priv))
+		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
+	return count;
 }
 
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index acf3bf6..0b61551 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -92,14 +92,15 @@ static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct cmd_ds_mesh_access mesh_access;
+	u32 retry_limit;
 	int ret;
-	unsigned long retry_limit;
 
 	memset(&mesh_access, 0, sizeof(mesh_access));
 	mesh_access.data[0] = cpu_to_le32(CMD_ACT_SET);
 
-	if (!strict_strtoul(buf, 10, &retry_limit))
-		return -ENOTSUPP;
+	ret = kstrtou32(buf, 10, &retry_limit);
+	if (ret < 0)
+		return ret;
 	if (retry_limit > 15)
 		return -ENOTSUPP;
 
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index cf0b73e..5ddbd34 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -901,19 +901,14 @@ static ssize_t rtl_store_debug_level(struct device *d,
 {
 	struct ieee80211_hw *hw = dev_get_drvdata(d);
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret) {
-		printk(KERN_DEBUG "%s is not in hex or decimal form.\n", buf);
-	} else {
-		rtlpriv->dbg.global_debuglevel = val;
-		printk(KERN_DEBUG "debuglevel:%x\n",
+	ret = kstrtou32(buf, 0, &rtlpriv->dbg.global_debuglevel);
+	if (ret < 0)
+		return ret;
+	printk(KERN_DEBUG "debuglevel:%x\n",
 		       rtlpriv->dbg.global_debuglevel);
-	}
-
-	return strnlen(buf, count);
+	return count;
 }
 
 static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index ec60777..450d2bf 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -261,27 +261,22 @@ static ssize_t gpio_power_write(struct file *file,
 	unsigned long value;
 	int ret;
 
-	mutex_lock(&wl->mutex);
-
 	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len)) {
-		ret = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &value);
+	ret = kstrtoul(buf, 0, &value);
 	if (ret < 0) {
 		wl1271_warning("illegal value in gpio_power");
-		goto out;
+		return ret;
 	}
 
+	mutex_lock(&wl->mutex);
 	if (value)
 		wl1271_power_on(wl);
 	else
 		wl1271_power_off(wl);
-
-out:
 	mutex_unlock(&wl->mutex);
 	return count;
 }
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 062247e..2588871 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2543,17 +2543,15 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	unsigned long res;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &res);
-
+	ret = kstrtoul(buf, 10, &res);
 	if (ret < 0) {
 		wl1271_warning("incorrect value written to bt_coex_mode");
 		return count;
 	}
+	res = !!res;
 
 	mutex_lock(&wl->mutex);
 
-	res = !!res;
-
 	if (res == wl->sg_enabled)
 		goto out;
 
-- 
1.7.3.4

