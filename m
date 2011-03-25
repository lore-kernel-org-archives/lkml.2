Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1CYX6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:58:15 -0400
Received: from kroah.org ([198.145.64.141]:48861 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab1CYX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:36 2011
Message-Id: <20110325235636.672054980@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:55:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>
Subject: [02/23] shmem: let shared anonymous be nonlinear again
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=shmem-let-shared-anonymous-be-nonlinear-again.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


