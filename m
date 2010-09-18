Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0IRStQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:49:16 -0400
Received: from kroah.org ([198.145.64.141]:38920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab0IRSse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:34 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:46:21 2010
Message-Id: <20100918184621.064344908@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:44:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [02/11] ath9k_hw: fix parsing of HT40 5 GHz CTLs
In-Reply-To: <20100918184651.GA14224@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -554,7 +554,7 @@ enum ath9k_cipher {
 
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
-#define CTL_MODE_M              7
+#define CTL_MODE_M              0xf
 #define CTL_11A                 0
 #define CTL_11B                 1
 #define CTL_11G                 2


