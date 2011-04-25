Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1DYUqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:46:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34290 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab1DYUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:45 -0400
Message-Id: <20110425200237.468864851@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 103/173] shmem: let shared anonymous be nonlinear again
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hughd@google.com>

commit bee4c36a5cf5c9f63ce1d7372aa62045fbd16d47 upstream.

Up to 2.6.22, you could use remap_file_pages(2) on a tmpfs file or a
shared mapping of /dev/zero or a shared anonymous mapping.  In 2.6.23 we
disabled it by default, but set VM_CAN_NONLINEAR to enable it on safe
mappings.  We made sure to set it in shmem_mmap() for tmpfs files, but
missed it in shmem_zero_setup() for the others.  Fix that at last.

Reported-by: Kenny Simpson <theonetruekenny@yahoo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2691,5 +2691,6 @@ int shmem_zero_setup(struct vm_area_stru
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }


