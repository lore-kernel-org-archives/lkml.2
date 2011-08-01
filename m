Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1HAX0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:26:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab1HAXZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:54 2011
Message-Id: <20110801232054.523781880@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [39/70] ath5k: fix incorrect use of drvdata in sysfs code
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit 95acbd432b4c6498c5b4b2f92e0e05e3c032d4f8 upstream.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/sysfs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -10,7 +10,8 @@ static ssize_t ath5k_attr_show_##name(st
 			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
 }									\
 									\
@@ -18,7 +19,8 @@ static ssize_t ath5k_attr_store_##name(s
 			struct device_attribute *attr,			\
 			const char *buf, size_t count)			\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	int val;							\
 									\
 	val = (int)simple_strtoul(buf, NULL, 10);			\
@@ -33,7 +35,8 @@ static ssize_t ath5k_attr_show_##name(st
 			struct device_attribute *attr,			\
 			char *buf)					\
 {									\
-	struct ath5k_softc *sc = dev_get_drvdata(dev);			\
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
+	struct ath5k_softc *sc = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get); 			\
 }									\
 static DEVICE_ATTR(name, S_IRUGO, ath5k_attr_show_##name, NULL)


