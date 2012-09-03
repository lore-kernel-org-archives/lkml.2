Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2ICOZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:25:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41170 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2ICOZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:25:15 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] kernel/sys.c: call disable_nonboot_cpus in kernel_restart
Date: Mon,  3 Sep 2012 22:24:58 +0800
Message-Id: <1346682298-13958-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like kernel_power_off calls disable_nonboot_cpus, we may want to have
kernel_restart call disable_nonboot_cpus as well.  Doing so can help
the machines that require boot cpu be the last alive cpu during reboot
to survive with kernel restart.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 kernel/sys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 241507f..6fab59a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -368,6 +368,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
+	disable_nonboot_cpus();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
-- 
1.7.5.4

