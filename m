Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0CWRIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:08:18 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38299 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0CWRIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:08:17 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd: Replace the dangerous to_fsl_upm_nand macro with an inline function
Date: Tue, 23 Mar 2010 18:08:16 +0100
Message-ID: <87iq8n0xvj.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original macro worked only when applied to variables named 'mtd'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement is preferred.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 drivers/mtd/nand/fsl_upm.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index 071a60c..02d1688 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -48,7 +48,10 @@ struct fsl_upm_nand {
 	uint32_t wait_flags;
 };
 
-#define to_fsl_upm_nand(mtd) container_of(mtd, struct fsl_upm_nand, mtd)
+inline struct fsl_upm_nand *to_fsl_upm_nand(struct mtd_info *mtdinfo)
+{
+	return container_of(mtdinfo, struct fsl_upm_nand, mtd);
+}
 
 static int fun_chip_ready(struct mtd_info *mtd)
 {
-- 
1.5.6.5

