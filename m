Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1CXMxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:53:32 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:54745 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1CXMxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:53:31 -0400
Date: Thu, 24 Mar 2011 13:53:16 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: akpm@linux-foundation.org
Cc: nai.xia@gmail.com, aarcange@redhat.com, chrisw@sous-sol.org,
        hugh.dickins@tiscali.co.uk, ieidus@redhat.com, riel@redhat.com,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: +
 ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages.patch
 added to -mm tree
Message-ID: <20110324125316.GA2310@cmpxchg.org>
References: <201103012341.p21Nf64e006469@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103012341.p21Nf64e006469@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 03:41:06PM -0800, akpm@linux-foundation.org wrote:
> diff -puN include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages include/linux/mmzone.h
> --- a/include/linux/mmzone.h~ksm-add-vm_stat-and-meminfo-entry-to-reflect-pte-mapping-to-ksm-pages
> +++ a/include/linux/mmzone.h
> @@ -115,6 +115,9 @@ enum zone_stat_item {
>  	NUMA_OTHER,		/* allocation from other node */
>  #endif
>  	NR_ANON_TRANSPARENT_HUGEPAGES,
> +#ifdef CONFIG_KSM
> +	NR_KSM_PAGES_SHARING,
> +#endif
>  	NR_VM_ZONE_STAT_ITEMS };

This adds a zone stat item without a corresponding entry in
vm_stat_text.  As a result, all vm event entries in /proc/vmstat show
the value of the respective previous counter.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 5ce2d0a..fca991c 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -886,6 +886,9 @@ static const char * const vmstat_text[] = {
 	"numa_other",
 #endif
 	"nr_anon_transparent_hugepages",
+#ifdef CONFIG_KSM
+	"nr_ksm_pages_sharing",
+#endif
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
 
