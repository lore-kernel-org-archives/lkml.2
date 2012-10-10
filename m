Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2JJTls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:41:48 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48714
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2JJTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:41:42 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 1/2] mm: Export vm_committed_as
Date: Wed, 10 Oct 2012 13:01:44 -0700
Message-Id: <1349899305-544-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1349899270-503-1-git-send-email-kys@microsoft.com>
References: <1349899270-503-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The policy engine on the host expects the guest to report the
committed_as. Since this variable is not exported,
export this symbol.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 mm/mmap.c  |    1 +
 mm/nommu.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2d94235..77a9166 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -87,6 +87,7 @@ int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
  * other variables. It can be updated by several CPUs frequently.
  */
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
+EXPORT_SYMBOL_GPL(vm_committed_as);
 
 /*
  * Check that a process has enough memory to allocate a new virtual
diff --git a/mm/nommu.c b/mm/nommu.c
index 45131b4..55bd7a2 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -68,6 +68,7 @@ atomic_long_t mmap_pages_allocated;
 
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
+EXPORT_SYMBOL_GPL(vm_committed_as);
 
 /* list of mapped, potentially shareable regions */
 static struct kmem_cache *vm_region_jar;
-- 
1.7.4.1

