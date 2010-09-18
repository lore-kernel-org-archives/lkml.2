Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0IRTBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:54 -0400
Received: from kroah.org ([198.145.64.141]:51162 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab0IRTBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:19 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:54 2010
Message-Id: <20100918185954.259380885@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [017/123] ath9k_hw: fix parsing of HT40 5 GHz CTLs
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=ath9k_hw-fix-parsing-of-ht40-5-ghz-ctls.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 904879748d7439a6dabdc6be9aad983e216b027d upstream.

The 5 GHz CTL indexes were not being read for all hardware
devices due to the masking out through the CTL_MODE_M mask
being one bit too short. Without this the calibrated regulatory
maximum values were not being picked up when devices operate
on 5 GHz in HT40 mode. The final output power used for Atheros
devices is the minimum between the calibrated CTL values and
what CRDA provides.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/regd.h         |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -60,7 +60,7 @@
 
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
+#define CTL_MODE_M              0xf
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -31,7 +31,6 @@ enum ctl_group {
 #define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2


