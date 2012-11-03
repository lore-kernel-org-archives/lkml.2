Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2KCLCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:02:25 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62865
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab2KCK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245668"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Achim Leubner <achim_leubner@adaptec.com>
Cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/16] drivers/scsi/gdth.c: use WARN
Date: Sat,  3 Nov 2012 11:58:28 +0100
Message-Id: <1351940317-14812-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

If (count) is also merged into WARN, for further conciseness.

A simplified version of the semantic patch that makes part of this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/gdth.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..0dbcb27 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2318,11 +2318,10 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
                 break;
             buffer += cpnow;
         }
-    } else if (count) {
-        printk("GDT-HA %d: SCSI command with no buffers but data transfer expected!\n",
-               ha->hanum);
-        WARN_ON(1);
     }
+	else
+		WARN(count, "GDT-HA %d: SCSI command with no buffers but data transfer expected!\n",
+			     ha->hanum);
 }
 
 static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
