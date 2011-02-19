Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1BSX3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 18:29:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1BSX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 18:29:23 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Stefan Weil <weil@mail.berlios.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: brcm80211: Fix memory leak after kmalloc failure
Date: Sun, 20 Feb 2011 00:29:11 +0100
Message-Id: <1298158151-22903-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:ePURRHppb3MNzk8IdwxkRImBEy5FsdDcKOrR6rFUBPV
 R5uR2bXCSzacTAt5Dd+lFZenONGq+zmHDLzQ/jxAcMXwFyhsNu
 5npyQTKITctShohGAG692E6xkyGf5b9Ch7PgSFkoAaYb3oSUce
 SY07KasTS+a1kf1JWaBF6nQNYy4C1xM1ri1+xgv9cht/OskEd4
 LBxXpeacAkLZKRBC8NROZGSo+XJB+cYsylT5EgDdNjcnsrXOIF
 5s5GuGPezPORi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was spotted by cppcheck:

drivers/staging/brcm80211/phy/wlc_phy_lcn.c:4053: error: Memory leak: ptr

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
index 3ac2b49..9e2cb60 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
@@ -4050,6 +4050,7 @@ wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 
 	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == phy_c32) {
+		kfree(ptr);
 		return;
 	}
 	phy_c26 = read_phy_reg(pi, 0x6da);
-- 
1.7.2.3

