Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2KZRcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:32:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796Ab2KZRMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 205/270] Staging: android: binder: Allow using highmem for binder buffers
Date: Mon, 26 Nov 2012 14:58:15 -0200
Message-Id: <1353949160-26803-206-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>

commit 585650dcec88e704a19bb226a34b6a7166111623 upstream.

The default kernel mapping for the pages allocated for the binder
buffers is never used. Set the __GFP_HIGHMEM flag when allocating
these pages so we don't needlessly use low memory pages that may
be required elsewhere.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 80acd0e..223639a 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -655,7 +655,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 
 		BUG_ON(*page);
-		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page == NULL) {
 			printk(KERN_ERR "binder: %d: binder_alloc_buf failed "
 			       "for page at %p\n", proc->pid, page_addr);
-- 
1.7.9.5

