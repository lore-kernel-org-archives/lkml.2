Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab2FENMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:12:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46637 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761880Ab2FENLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:18 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 17/21] vfs: do_last(): clean up error handling
Date: Tue,  5 Jun 2012 15:10:28 +0200
Message-Id: <1338901832-14049-18-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 47d81f4..55f5f27 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2625,21 +2625,14 @@ common:
 	if (error)
 		goto exit_fput;
 opened:
-	if (!IS_ERR(filp)) {
-		error = ima_file_check(filp, op->acc_mode);
-		if (error) {
-			fput(filp);
-			filp = ERR_PTR(error);
-		}
-	}
-	if (!IS_ERR(filp)) {
-		if (will_truncate) {
-			error = handle_truncate(filp);
-			if (error) {
-				fput(filp);
-				filp = ERR_PTR(error);
-			}
-		}
+	error = ima_file_check(filp, op->acc_mode);
+	if (error)
+		goto exit_fput;
+
+	if (will_truncate) {
+		error = handle_truncate(filp);
+		if (error)
+			goto exit_fput;
 	}
 out:
 	if (want_write)
-- 
1.7.7

