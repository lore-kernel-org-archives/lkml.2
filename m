Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1BXVME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:12:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BXVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:12:02 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: greg@kroah.com
Cc: Stefan Weil <weil@mail.berlios.de>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: brcm80211: Fix memory leak after kmalloc failure
Date: Thu, 24 Feb 2011 22:11:48 +0100
Message-Id: <1298581908-16274-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D66C912.8090205@mail.berlios.de>
References: <4D66C912.8090205@mail.berlios.de>
X-Provags-ID: V02:K0:+anVnlN+6Lq47FeF7EiRXFnVyXKlveu7wT4/RD0K7wf
 vaTmqVWbS09qnu5OuGBWOR6I1A3IotB7n9Or/CLS8WZrxY/4K4
 CvLeJW4nUv//eq8UlOaAeVp57eRVImh6mcULHQ+OiuGsaNhluN
 AQPEF4MJWbHWeJd3qFm+qZx4FIahNNv6G3z2E/2F3lu780ibUc
 1ZGcePNmBgGmi4N40ZzH9qH8psdgzzuiPoPq/AnWHK55zkPPMZ
 fol0uKIDbrO37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error was spotted by cppcheck:

drivers/staging/brcm80211/phy/wlc_phy_lcn.c:4053: error: Memory leak: ptr

v2:
Rebased patch on linux-next (file was moved to a new directory).

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
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
1.7.2.3

