Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1C1CD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:03:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:62547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab1C1CDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,252,1299484800"; 
   d="scan'208";a="672215953"
Subject: [PATCH]mmap: add alignment for some variables
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 09:58:56 +0800
Message-ID: <1301277536.3981.27.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some variables have correct alignment.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c	2011-03-24 10:59:39.000000000 +0800
+++ linux/mm/mmap.c	2011-03-24 10:59:42.000000000 +0800
@@ -84,10 +84,10 @@ pgprot_t vm_get_page_prot(unsigned long
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 
-int sysctl_overcommit_memory = OVERCOMMIT_GUESS;  /* heuristic overcommit */
-int sysctl_overcommit_ratio = 50;	/* default is 50% */
+int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
+int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
-struct percpu_counter vm_committed_as;
+struct percpu_counter vm_committed_as ____cacheline_internodealigned_in_smp;
 
 /*
  * Check that a process has enough memory to allocate a new virtual


