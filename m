Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2KCWDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:03:55 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36338 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab2KCWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 7/9] quota: Use the pre-processor to compile out quotactl_cmd_write when !CONFIG_BLOCK
Date: Sat,  3 Nov 2012 23:02:28 +0100
Message-Id: <1351980150-24145-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quotactl_cmd_write() is only ever invoked when BLOCK is configured. When
!CONFIG_BLOCK, the build warning below is displayed. Let's fix that.

fs/quota/quota.c:311:12: warning: ‘quotactl_cmd_write’ defined but not used [-Wunused-function]

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/quota/quota.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index af1661f..c7314f1 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -307,6 +307,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 	}
 }
 
+#ifdef CONFIG_BLOCK
+
 /* Return 1 if 'cmd' will block on frozen filesystem */
 static int quotactl_cmd_write(int cmd)
 {
@@ -322,6 +324,8 @@ static int quotactl_cmd_write(int cmd)
 	return 1;
 }
 
+#endif /* CONFIG_BLOCK */
+
 /*
  * look up a superblock on which quota ops will be performed
  * - use the name of a block device to find the superblock thereon
-- 
1.7.9.5

