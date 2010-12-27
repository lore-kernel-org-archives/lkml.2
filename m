Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0L0PjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:39:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab0L0PjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:39:17 -0500
From: David Sterba <dsterba@suse.cz>
To: mchehab@redhat.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH] i7core_edac: fix misuse of logical operation in place of bitop
Date: Mon, 27 Dec 2010 16:39:12 +0100
Message-Id: <1293464352-21804-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.578.g6068a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 drivers/edac/i7core_edac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 362861c..f41a34e 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -731,7 +731,7 @@ static int get_dimm_config(const struct mem_ctl_info *mci)
 			debugf1("\t\t%#x\t%#x\t%#x\n",
 				(value[j] >> 27) & 0x1,
 				(value[j] >> 24) & 0x7,
-				(value[j] && ((1 << 24) - 1)));
+				(value[j] & ((1 << 24) - 1)));
 	}
 
 	return 0;
@@ -1670,7 +1670,7 @@ static void i7core_mce_output_error(struct mem_ctl_info *mci,
 	char *type, *optype, *err, *msg;
 	unsigned long error = m->status & 0x1ff0000l;
 	u32 optypenum = (m->status >> 4) & 0x07;
-	u32 core_err_cnt = (m->status >> 38) && 0x7fff;
+	u32 core_err_cnt = (m->status >> 38) & 0x7fff;
 	u32 dimm = (m->misc >> 16) & 0x3;
 	u32 channel = (m->misc >> 18) & 0x3;
 	u32 syndrome = m->misc >> 32;
-- 
1.7.3.4.578.g6068a

