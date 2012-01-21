Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab2AUD5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 22:57:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33910 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab2AUD4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 22:56:48 -0500
From: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Christopher Lais <chris+android@zenthought.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2] Staging: android: binder: Don't call dump_stack in binder_vma_open
Date: Fri, 20 Jan 2012 19:56:21 -0800
Message-Id: <1327118181-3542-3-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327118181-3542-1-git-send-email-arve@android.com>
References: <1327118181-3542-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user-space partially unmaps the driver, binder_vma_open
would dump the kernel stack. This is not a kernel bug however
and will be treated as if the whole area was unmapped once
binder_vma_close gets called.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 846b429..f0b7e66 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2765,7 +2765,6 @@ static void binder_vma_open(struct vm_area_struct *vma)
 		     proc->pid, vma->vm_start, vma->vm_end,
 		     (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
 		     (unsigned long)pgprot_val(vma->vm_page_prot));
-	dump_stack();
 }
 
 static void binder_vma_close(struct vm_area_struct *vma)
-- 
1.7.7.3

