Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2JIUPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:15:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58778 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2JIUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:14:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH v2 5/8] clk: don't mark clkdev_add_table as init
Date: Tue,  9 Oct 2012 22:13:55 +0200
Message-Id: <1349813638-4617-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349813638-4617-1-git-send-email-arnd@arndb.de>
References: <1349813638-4617-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:C6OCCUA0JvCAokhtTYUv/vSDeZTXYIrHY3xFn0csBQl
 wuQ/zbo5/FL0HPFwz+5jW+1yIV2sCXh8RRDbtUIz4EpsT/DI5A
 EBfQjoma5DyTuGinbteYWOA7eJW6Jus6+q4VQ3WMajHnYSFmsh
 OG2C7sutb/sjvz/nShNwsmDZVxp9k6/9tInVYO8RO3XobckWch
 R5FNI3BmOC3avCuQJ4RvxCVwJPPN3F5jisJvfsfoxAq/SNFrkS
 1wYa+poqJgVRGRTD8ajsLR8yWhb9R0btWmeMUSD8uo7SC3cvTy
 o3tg5bxaCDt11KXmaVvLJnDR4j3z82322KbhdDOqx57ookKkJ9
 t4S0/E70jnVPxB+yoNt9ojn0kNF2VAqpeMAUHOqH6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
which means we might be calling it after the __init section is
discarded.

Without this patch, building mini2440_defconfig results in:

WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
The function s3c2440_clk_add() references
the function __init clkdev_add_table().
This is often because s3c2440_clk_add lacks a __init
annotation or the annotation of clkdev_add_table is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/clk/clkdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..6956857 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -179,7 +179,7 @@ void clkdev_add(struct clk_lookup *cl)
 }
 EXPORT_SYMBOL(clkdev_add);
 
-void __init clkdev_add_table(struct clk_lookup *cl, size_t num)
+void clkdev_add_table(struct clk_lookup *cl, size_t num)
 {
 	mutex_lock(&clocks_mutex);
 	while (num--) {
-- 
1.7.10

