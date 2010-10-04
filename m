Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0JDPOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 11:14:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34112 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab0JDPOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 11:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vvNkZIlP6rlrCkc78QCmLQ28AurkNHqFqziQMyirBHedHUeVCLiKlnnMIafgLxHnKk
         ugXzF32I7asYWSBdTT3hpB/oraENI7X5G+dNdN+bejkPd94glFYbLwQSKYYoO5AX6GGh
         j5vsnMU+DSCPMtwcG6iOQbZ6Bt6otHGfPt/h0=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Remove unnecessary goto statement
Date: Tue,  5 Oct 2010 00:13:59 +0900
Message-Id: <1286205239-2662-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove goto statement which jumps to very next line. Also remove
target label because it is no longer used anywhere.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/transaction.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 5ae71e7..981449c 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -293,9 +293,7 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		jbd_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
-		goto out;
 	}
-out:
 	return handle;
 }
 
-- 
1.7.0.4

