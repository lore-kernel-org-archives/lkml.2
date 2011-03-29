Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1C2AyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:54:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:3252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1C2AyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:54:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,258,1299484800"; 
   d="scan'208";a="726254430"
Subject: Re: [PATCH]mmap: add alignment for some variables
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <m2oc4v18x8.fsf@firstfloor.org>
References: <1301277536.3981.27.camel@sli10-conroe>
	 <m2oc4v18x8.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 08:54:14 +0800
Message-ID: <1301360054.3981.31.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 00:55 +0800, Andi Kleen wrote:
> Shaohua Li <shaohua.li@intel.com> writes:
> 
> > Make some variables have correct alignment.
> 
> Nit: __read_mostly doesn't change alignment, just the section.
> Please fix the description. Other than that it looks good.
sure.

Make some variables have correct alignment/section to avoid cache issue.
In a workload which heavily does mmap/munmap, the variables will be used
frequently.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/mmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c	2011-03-29 08:30:12.000000000 +0800
+++ linux/mm/mmap.c	2011-03-29 08:30:54.000000000 +0800
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


