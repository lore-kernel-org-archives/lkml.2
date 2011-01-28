Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1A1EFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:18 -0500
Received: from mail.perches.com ([173.55.12.10]:3454 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1A1EEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:55 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] staging: ath6kl: Convert A_UINT8 is_amsdu and is_acl_data_frame to A_BOOL
Date: Thu, 27 Jan 2011 20:04:29 -0800
Message-Id: <3a5cf32b0de8cd3153d385e2198d7aa4c787697e.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use A_BOOL as appropriate for actual variable uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 01ebdf1..5a5e085 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -3630,7 +3630,9 @@ ar6000_rx(void *Context, HTC_PACKET *pPacket)
             wmi_control_rx(ar->arWmi, skb);
         } else {
                 WMI_DATA_HDR *dhdr = (WMI_DATA_HDR *)A_NETBUF_DATA(skb);
-                A_UINT8 is_amsdu, tid, is_acl_data_frame;
+                A_BOOL is_amsdu;
+                A_UINT8 tid;
+                A_BOOL is_acl_data_frame;
                 is_acl_data_frame = WMI_DATA_HDR_GET_DATA_TYPE(dhdr) == WMI_DATA_HDR_DATA_TYPE_ACL;
 #ifdef CONFIG_PM 
                 ar6000_check_wow_status(ar, NULL, FALSE);
@@ -3751,7 +3753,7 @@ ar6000_rx(void *Context, HTC_PACKET *pPacket)
                         }
                     }
 
-                    is_amsdu = WMI_DATA_HDR_IS_AMSDU(dhdr);
+                    is_amsdu = WMI_DATA_HDR_IS_AMSDU(dhdr) ? TRUE : FALSE;
                     tid = WMI_DATA_HDR_GET_UP(dhdr);
                     seq_no = WMI_DATA_HDR_GET_SEQNO(dhdr);
                     meta_type = WMI_DATA_HDR_GET_META(dhdr);
-- 
1.7.4.rc3

