Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab1CTFar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 01:30:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26587 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1CTFao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 01:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=W5vOxNA3cH0yYV+VecGjBRMvVGNY/HXSbolOJQDJDSXvTtLMHZdehjKOHCSDIapeZZ
         qNZ5A4VkSXAydGTCuoTw==
Date: Sat, 19 Mar 2011 22:30:28 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kenny Simpson <theonetruekenny@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] shmem: let shared anonymous be nonlinear again
Message-ID: <alpine.LSU.2.00.1103192227570.1659@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to 2.6.22, you could use remap_file_pages(2) on a tmpfs file or a
shared mapping of /dev/zero or a shared anonymous mapping.  In 2.6.23
we disabled it by default, but set VM_CAN_NONLINEAR to enable it on
safe mappings.  We made sure to set it in shmem_mmap() for tmpfs files,
but missed it in shmem_zero_setup() for the others.  Fix that at last.

Reported-by: Kenny Simpson <theonetruekenny@yahoo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.38/mm/shmem.c	2011-03-14 18:20:32.000000000 -0700
+++ linux/mm/shmem.c	2011-03-19 15:09:26.000000000 -0700
@@ -2791,5 +2791,6 @@ int shmem_zero_setup(struct vm_area_stru
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
