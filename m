Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2J3Iem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:34:42 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:41403 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab2J3Ieh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:34:37 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: owasserm@redhat.com, quintela@redhat.com, avi@redhat.com,
        pbonzini@redhat.com, aliguori@us.ibm.com, stefanha@gmail.com,
        dlaor@redhat.com, mdroth@linux.vnet.ibm.com,
        yoshikawa.takuya@oss.ntt.co.jp, benoit.hudzia@gmail.com,
        aarcange@redhat.com, t.hirofuchi@aist.go.jp, satoshi.itoh@aist.go.jp,
        chegu_vinod@hp.com, gregkh@linuxfoundation.org, arnd@arndb.de
Subject: [PATCH v4 1/2] export necessary symbols
Date: Tue, 30 Oct 2012 17:34:35 +0900
Message-Id: <8137fb4109520b0a9af1d03f9171ec9e961f424d.1351584882.git.yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1351584881.git.yamahata@valinux.co.jp>
References: <cover.1351584881.git.yamahata@valinux.co.jp>
In-Reply-To: <cover.1351584881.git.yamahata@valinux.co.jp>
References: <cover.1351584881.git.yamahata@valinux.co.jp>
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
 3 files changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7acf43b..bc9fd53 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2787,6 +2787,7 @@ int mem_cgroup_newpage_charge(struct page *page,
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
 					MEM_CGROUP_CHARGE_TYPE_ANON);
 }
+EXPORT_SYMBOL_GPL(mem_cgroup_cache_charge);
 
 /*
  * While swap-in, try_charge -> commit or cancel, the page is locked.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..3df6cf5 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1947,6 +1947,7 @@ retry_cpuset:
 		goto retry_cpuset;
 	return page;
 }
+EXPORT_SYMBOL_GPL(alloc_pages_vma);
 
 /**
  * 	alloc_pages_current - Allocate pages.
diff --git a/mm/shmem.c b/mm/shmem.c
index 67afba5..41eaefd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2840,6 +2840,7 @@ int shmem_zero_setup(struct vm_area_struct *vma)
 	vma->vm_ops = &shmem_vm_ops;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(shmem_zero_setup);
 
 /**
  * shmem_read_mapping_page_gfp - read into page cache, using specified page allocation flags.
-- 
1.7.10.4

