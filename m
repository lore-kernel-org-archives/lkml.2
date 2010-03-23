Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0CWRJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:09:11 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38303 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0CWRJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:09:10 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH] mtd: Replace the dangerous mtd_to_flctl macro with an inline function
Date: Tue, 23 Mar 2010 18:09:09 +0100
Message-ID: <87eijb0xu2.fsf@tac.ki.iif.hu>
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
 include/linux/mtd/sh_flctl.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/sh_flctl.h b/include/linux/mtd/sh_flctl.h
index ab77609..1278465 100644
--- a/include/linux/mtd/sh_flctl.h
+++ b/include/linux/mtd/sh_flctl.h
@@ -93,7 +93,10 @@
 #define INIT_FL4ECCRESULT_VAL	0x03FF03FF
 #define LOOP_TIMEOUT_MAX	0x00010000
 
-#define mtd_to_flctl(mtd)	container_of(mtd, struct sh_flctl, mtd)
+inline struct sh_flctl *mtd_to_flctl(struct mtd_info *mtdinfo)
+{
+	return container_of(mtdinfo, struct sh_flctl, mtd);
+}
 
 struct sh_flctl {
 	struct mtd_info		mtd;
-- 
1.5.6.5

