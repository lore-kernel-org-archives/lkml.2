Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1HTEO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 00:14:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60294 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1HTEOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 00:14:15 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@suse.de, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] drivers:uio:fix section mismatch in uio_pdrv_genirq.c
Date: Sat, 20 Aug 2011 12:12:07 +0800
Message-Id: <1313813528-30913-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Remove the __devinitconst to fix the section mismatch.

WARNING: drivers/uio/built-in.o(.data+0x2e8): Section mismatch in
reference from the variable uio_pdrv_genirq to the variable
.devinit.rodata:uio_of_genirq_match
The variable uio_pdrv_genirq references
the variable __devinitconst uio_of_genirq_match
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one,
*_console

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/uio/uio_pdrv_genirq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index bae96d2..0b2ed71 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -253,7 +253,7 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 };
 
 #ifdef CONFIG_OF
-static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
+static const struct of_device_id uio_of_genirq_match[] = {
 	{ /* empty for now */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
-- 
1.7.4.1

