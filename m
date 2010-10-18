Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0JRQiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:38:01 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:53138 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab0JRQiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:38:00 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        toralf.foerster@gmx.de, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/1] hostfs: fix UML crash
Date: Mon, 18 Oct 2010 18:36:54 +0200
Message-Id: <1287419814-20086-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

365b1818 resized f_spare within struct statfs.
hostfs accesses f_spare directly and needs an update.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
---
 fs/hostfs/hostfs_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index 6777aa0..ce2f168 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -388,6 +388,6 @@ int do_statfs(char *root, long *bsize_out, long long *blocks_out,
 	spare_out[1] = buf.f_spare[1];
 	spare_out[2] = buf.f_spare[2];
 	spare_out[3] = buf.f_spare[3];
-	spare_out[4] = buf.f_spare[4];
+
 	return 0;
 }
-- 
1.6.6.1

