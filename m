Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab0HKNBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:01:01 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:40173 "EHLO
	homiemail-a7.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257Ab0HKNA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:00:59 -0400
Subject: [PATCH] jbd: Remove redundant NULL check upon kfree()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:00:54 -0400
Message-ID: <1281531654.2067.2.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jbd: Remove redundant NULL check upon kfree().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/jbd/transaction.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 5ae71e7..5e98130 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -232,8 +232,7 @@ repeat_locked:
 
 	lock_map_acquire(&handle->h_lockdep_map);
 out:
-	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+	kfree(new_transaction);
 	return ret;
 }
 
-- 
1.7.0.4

