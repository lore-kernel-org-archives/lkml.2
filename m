Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1LAVl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:41:29 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43611 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753526Ab1LAVl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:41:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: devel@driverdev.osuosl.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David McCullough <davidm@snapgear.com>,
        D Jeff Dionne <jeff@uClinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH 01/11] mm: export vmalloc_sync_all symbol to GPL modules
Date: Thu,  1 Dec 2011 16:41:13 -0500
Message-Id: <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTTng needs this symbol exported. It calls it to ensure its tracing
buffers and allocated data structures never trigger a page fault. This
is required to handle page fault handler tracing and NMI tracing
gracefully.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christoph Hellwig <hch@infradead.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>
CC: David Howells <dhowells@redhat.com>
CC: David McCullough <davidm@snapgear.com>
CC: D Jeff Dionne <jeff@uClinux.org>
CC: Greg Ungerer <gerg@snapgear.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
---
 mm/nommu.c   |    1 +
 mm/vmalloc.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index b982290..b22a0d9 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -441,6 +441,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
 void  __attribute__((weak)) vmalloc_sync_all(void)
 {
 }
+EXPORT_SYMBOL_GPL(vmalloc_sync_all);
 
 /**
  *	alloc_vm_area - allocate a range of kernel address space
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3231bf3..37ddce5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2137,6 +2137,7 @@ EXPORT_SYMBOL(remap_vmalloc_range);
 void  __attribute__((weak)) vmalloc_sync_all(void)
 {
 }
+EXPORT_SYMBOL_GPL(vmalloc_sync_all);
 
 
 static int f(pte_t *pte, pgtable_t table, unsigned long addr, void *data)
-- 
1.7.5.4

