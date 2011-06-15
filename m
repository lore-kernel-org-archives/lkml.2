Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1FOWZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:25:40 -0400
Received: from mta31.charter.net ([216.33.127.82]:42155 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1FOWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:25:38 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=IjlVrzqBmqAA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=sjYXV76F8JLtp2qyPm0A:9 a=aEXJh0E5FJhFWPT7sHUA:7
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: gregkh@suse.de
Cc: brudley@broadcom.com, henryp@broadcom.com, dowan@broadcom.com,
        rvossen@broadcom.com, arend@broadcom.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] staging: brcm80211: return false if not a broadcom board
Date: Wed, 15 Jun 2011 17:25:09 -0500
Message-Id: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code looks wrong to me. I think it meant to return false
if the board's vendor id isn't Broadcom's.

Compile tested only.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 4534926..ee13238 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -1943,7 +1943,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
 	}
 
 	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
-		return goodboard;
+		goodboard = false; 
 
 	return goodboard;
 }
-- 
1.7.2.5

