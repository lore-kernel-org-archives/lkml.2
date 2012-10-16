Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2JPWaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:30:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50838 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2JPWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:30:30 -0400
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: gregkh@linuxfoundation.org
Cc: xiaobing.tu@intel.com, ccross@android.com, davej@redhat.com,
        akpm@linux-foundation.org, mingo@elte.hu, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, di.zhang@intel.com, xindong.ma@intel.com,
        alex.zuo@intel.com,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 4/4] Staging: android: binder: Allow using highmem for binder buffers
Date: Tue, 16 Oct 2012 15:29:55 -0700
Message-Id: <1350426595-18059-4-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426595-18059-1-git-send-email-arve@android.com>
References: <20121016071101.GA5172@kroah.com>
 <1350426595-18059-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default kernel mapping for the pages allocated for the binder
buffers is never used. Set the __GFP_HIGHMEM flag when allocating
these pages so we don't needlessly use low memory pages that may
be required elsewhere.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 91ce956..9fbc06e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -583,7 +583,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 
 		BUG_ON(*page);
-		*page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		*page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
 		if (*page == NULL) {
 			pr_err("binder: %d: binder_alloc_buf failed "
 			       "for page at %p\n", proc->pid, page_addr);
-- 
1.7.7.3

