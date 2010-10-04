Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0JDI06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:26:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58630 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab0JDI05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gXXfL37lGqwxVxYi1r9HZbEgehSakPer9anHS6PLpFF6tfLmgkd4BZ/7+X4wSm/sSN
         F612ZDKri8IzW3RCPZvGqns+HcTW2k+D4xp2JQCMacVBcElE2uGKnkwSCRH2TX/YtOsW
         MoRPNQvrhFKSKgPMUq+rN+nPdx+O2gBbVCyCA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Move debug message into #ifdef area
Date: Mon,  4 Oct 2010 17:26:53 +0900
Message-Id: <1286180813-4653-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move call to jbd_debug() into #ifdef CONFIG_JBD_DEBUG block because
'dropped' is declared there. The code could be compiled without this
change anyway, simply because jbd_debug() expands to nothing if
!CONFIG_JBD_DEBUG but IMHO it doesn't look good in general.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/recovery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 81051da..5b43e96 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -296,10 +296,10 @@ int journal_skip_recovery(journal_t *journal)
 #ifdef CONFIG_JBD_DEBUG
 		int dropped = info.end_transaction -
 			      be32_to_cpu(journal->j_superblock->s_sequence);
-#endif
 		jbd_debug(1,
 			  "JBD: ignoring %d transaction%s from the journal.\n",
 			  dropped, (dropped == 1) ? "" : "s");
+#endif
 		journal->j_transaction_sequence = ++info.end_transaction;
 	}
 
-- 
1.7.0.4

