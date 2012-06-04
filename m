Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2FDJ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:58:46 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:43991 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2FDJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:58:41 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: owasserm@redhat.com, quintela@redhat.com, avi@redhat.com,
        pbonzini@redhat.com, aliguori@us.ibm.com, stefanha@gmail.com,
        dlaor@redhat.com, mdroth@linux.vnet.ibm.com,
        yoshikawa.takuya@oss.ntt.co.jp, benoit.hudzia@gmail.com,
        aarcange@redhat.com, t.hirofuchi@aist.go.jp, satoshi.itoh@aist.go.jp
Subject: [PATCH v3 1/2] export necessary symbols
Date: Mon,  4 Jun 2012 18:58:39 +0900
Message-Id: <b008ad1b0509a948a93510d7e86179c9e17e06db.1338803423.git.yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <cover.1338803423.git.yamahata@valinux.co.jp>
References: <cover.1338803423.git.yamahata@valinux.co.jp>
In-Reply-To: <cover.1338803423.git.yamahata@valinux.co.jp>
References: <cover.1338803423.git.yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 mm/memcontrol.c |    1 +
 mm/mempolicy.c  |    1 +
 mm/shmem.c      |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac35bcc..265ba2f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2761,6 +2761,7 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mem_cgroup_cache_charge);
 
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f15c1b2..ede02e2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1907,6 +1907,7 @@ retry_cpuset:
 		goto retry_cpuset;
 	return page;
 }
+EXPORT_SYMBOL_GPL(alloc_pages_vma);
 
 /**
  * 	alloc_pages_current - Allocate pages.
diff --git a/mm/shmem.c b/mm/shmem.c
index 585bd22..f2b8aa7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3041,6 +3041,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(shmem_zero_setup);
 
 /**
  * shmem_read_mapping_page_gfp - read into page cache, using specified page allocation flags.
-- 
1.7.1.1

