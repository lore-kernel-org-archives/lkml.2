Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1CPVYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:24:06 -0400
Received: from kroah.org ([198.145.64.141]:57647 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab1CPVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:23:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: devel@linuxdriverproject.org
Cc: Stefan Weil <weil@mail.berlios.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 584/961] staging: brcm80211: Fix memory leak after kmalloc failure
Date: Wed, 16 Mar 2011 14:03:47 -0700
Message-Id: <1300309804-3756-584-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309804-3756-1-git-send-email-gregkh@suse.de>
References: <20110316210300.GA3311@kroah.com>
 <1300309804-3756-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Weil <weil@mail.berlios.de>

This error was spotted by cppcheck:

drivers/staging/brcm80211/phy/wlc_phy_lcn.c:4053: error: Memory leak: ptr

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index 3fbbbb4..f027d50 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -4051,6 +4051,7 @@ wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 
 	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == phy_c32) {
+		kfree(ptr);
 		return;
 	}
 	phy_c26 = read_phy_reg(pi, 0x6da);
-- 
1.7.4.1

