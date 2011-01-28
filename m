Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1A1EFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:21 -0500
Received: from mail.perches.com ([173.55.12.10]:3462 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1A1EE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:56 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/15] staging: ath6kl: Convert sets of scanSpecificSsid to TRUE/FALSE.
Date: Thu, 27 Jan 2011 20:04:31 -0800
Message-Id: <eb4ab9bf5826cc6530da3223715478903c029be0.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use 0/1 for an A_BOOL.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/wireless_ext.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/wireless_ext.c b/drivers/staging/ath6kl/os/linux/wireless_ext.c
index dc32e2d..ea933d0 100644
--- a/drivers/staging/ath6kl/os/linux/wireless_ext.c
+++ b/drivers/staging/ath6kl/os/linux/wireless_ext.c
@@ -2510,14 +2510,14 @@ ar6000_ioctl_siwscan(struct net_device *dev,
                 return -EIO;
             if (wmi_probedSsid_cmd(ar->arWmi, 1, SPECIFIC_SSID_FLAG, req.essid_len, req.essid) != A_OK)
                 return -EIO;
-            ar->scanSpecificSsid = 1;
+            ar->scanSpecificSsid = TRUE;
         }
         else
         {
             if (ar->scanSpecificSsid) {
                 if (wmi_probedSsid_cmd(ar->arWmi, 1, DISABLE_SSID_FLAG, 0, NULL) != A_OK)
                     return -EIO;
-                 ar->scanSpecificSsid = 0;
+                 ar->scanSpecificSsid = FALSE;
             }
         }
     }
@@ -2526,7 +2526,7 @@ ar6000_ioctl_siwscan(struct net_device *dev,
         if (ar->scanSpecificSsid) {
             if (wmi_probedSsid_cmd(ar->arWmi, 1, DISABLE_SSID_FLAG, 0, NULL) != A_OK)
                 return -EIO;
-             ar->scanSpecificSsid = 0;
+             ar->scanSpecificSsid = FALSE;
         }
     }
 #endif
-- 
1.7.4.rc3

