Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1FNPR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:17:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56260 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1FNPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:17:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V5WIy5NQjxWDVDy8xVbJ40fhQOqX2K0smM1Djv7OTJ8aLczIr7nHhpkm/XpWaUnjZB
         5dtTqzKlL+oqcsd+mSqDx6Q3ZuHz+0+GbcTfJDNdSpA2suUNc38wGLUsaULPrIf4QA0l
         aQc5Cb2tcuK4mcT3jM54P5C2qDBHYde1JVuwc=
From: yxlraid@gmail.com
To: JBottomley@parallels.com
Cc: James.Bottomley@suse.de, jack_wang@usish.com,
        lucas.demarchi@profusion.mobi, maciej.trela@intel.com,
        dan.j.williams@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
Subject: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Tue, 14 Jun 2011 23:17:08 +0800
Message-Id: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

-- The value of child link rate should is minimum of link rate, or
   command will fail if child link rate is bigger than parent link rate.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/libsas/sas_expander.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 874e29d..6ccca09 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
 			sas_port_add_phy(port, phy->phy);
 		}
 	}
-	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
+	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
 	child->pathways = min(child->pathways, parent->pathways);
 }
 
-- 
1.7.5.4

