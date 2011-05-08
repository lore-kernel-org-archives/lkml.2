Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab1EHXBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:01:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1EHWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZaVQTAVr+hZCqW7xHHlCtIcXeLvkZPTRC+ysQE8UFoN5B62tT1G5oHF1edl/kjQn1g
         iY7HV5usnr6akoRxF51TiSu4jHHB1pDA1izS4eu72SP/lGJqKR/bFPkPh5R+MC3nkWOb
         SmLEajejVlUSx3nsCxMmQq1tEtUrf05q4h5pA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 028/115] sysctl: remove .child from kernel/ (ipc)
Date: Mon,  9 May 2011 00:38:40 +0200
Message-Id: <1304894407-32201-29-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 ipc/ipc_sysctl.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 56410fa..9e408a6 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -194,18 +194,14 @@ static struct ctl_table ipc_kern_table[] = {
 	{}
 };
 
-static struct ctl_table ipc_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= ipc_kern_table,
-	},
-	{}
+static const __initdata struct ctl_path ipc_path[] = {
+	{ .procname = "kernel" },
+	{ }
 };
 
 static int __init ipc_sysctl_init(void)
 {
-	register_sysctl_table(ipc_root_table);
+	register_sysctl_paths(ipc_path, ipc_kern_table);
 	return 0;
 }
 
-- 
1.7.5.134.g1c08b

