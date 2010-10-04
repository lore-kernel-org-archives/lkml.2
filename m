Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab0JDQDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:03:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49420 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0JDQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=k9ZBvwN/5Lwus5ItcKgiFL/NIm+V6iZB6v2TmJFHs2NoFYPU9g4UIZ3iNzRcz8M4hI
         E6ofc2WlaX08uB9E4KTGF8t2uqLkp/Yn8H7CFcyPhN1TZ3GMFlbFGM0cQ/ZdTMsA6CU9
         RuevX46PxrBlh8N+2QFtgykbje2trE+7umWF4=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: Use offset_in_page() instead of manual calculation
Date: Tue,  5 Oct 2010 01:03:40 +0900
Message-Id: <1286208220-5151-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/jbd/transaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 981449c..c9bb7a7 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -711,7 +711,7 @@ done:
 		J_EXPECT_JH(jh, buffer_uptodate(jh2bh(jh)),
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
-		offset = ((unsigned long) jh2bh(jh)->b_data) & ~PAGE_MASK;
+		offset = offset_in_page(jh2bh(jh)->b_data);
 		source = kmap_atomic(page, KM_USER0);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
 		kunmap_atomic(source, KM_USER0);
-- 
1.7.0.4

