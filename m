Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2DCPdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:33:06 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52830 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2DCPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:33:03 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] Kprobes : Recursively remove the directory on failure
Date: Tue,  3 Apr 2012 21:05:03 +0530
Message-Id: <1333467303-20130-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "kprobes" directory recursivly if "enabled" file creation fails

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..9b45515 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2251,7 +2251,7 @@ static int __kprobes debugfs_kprobe_init(void)
 	file = debugfs_create_file("enabled", 0600, dir,
 					&value, &fops_kp);
 	if (!file) {
-		debugfs_remove(dir);
+		debugfs_remove_recursive(dir);
 		return -ENOMEM;
 	}
 
-- 
1.7.3.4

