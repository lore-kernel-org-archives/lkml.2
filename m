Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2CEGjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:39:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57916 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2CEGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:39:48 -0500
Date: Mon, 5 Mar 2012 06:39:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] VM_GROWS{UP,DOWN} shouldn't be set on shmem VMAs
Message-ID: <20120305063947.GJ23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305063707.GH23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/mmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3f758c7..22e1a0b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1293,6 +1293,8 @@ munmap_back:
 		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
+		if (unlikely(vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
+			goto free_vma;
 		error = shmem_zero_setup(vma);
 		if (error)
 			goto free_vma;
-- 
1.7.2.5


