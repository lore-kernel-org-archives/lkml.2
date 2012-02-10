Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2BJWz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:55:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933074Ab2BJWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:04 -0500
MIME-Version: 1.0
Message-Id: <20120210224852.068792395@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [14/21] Staging: android: binder: Dont call dump_stack in binder_vma_open
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Arve Hjønnevåg <arve@android.com>

commit 3c1b86f17068cf6476fb2d022b9c8b44dedea2e5 upstream.

If user-space partially unmaps the driver, binder_vma_open
would dump the kernel stack. This is not a kernel bug however
and will be treated as if the whole area was unmapped once
binder_vma_close gets called.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/binder.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2741,7 +2741,6 @@ static void binder_vma_open(struct vm_ar
 		     proc->pid, vma->vm_start, vma->vm_end,
 		     (vma->vm_end - vma->vm_start) / SZ_1K, vma->vm_flags,
 		     (unsigned long)pgprot_val(vma->vm_page_prot));
-	dump_stack();
 }
 
 static void binder_vma_close(struct vm_area_struct *vma)


