Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab0JDDZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 23:25:34 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58775 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0JDDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 23:25:33 -0400
Date: Mon, 4 Oct 2010 12:24:51 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Izik Eidus <ieidus@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: Transparent Hugepage Support #30
Message-ID: <20101004032451.GA11622@spritzera.linux.bs1.fc.nec.co.jp>
References: <20100901190859.GA20316@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100901190859.GA20316@random.random>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experienced build error of "calling pte_alloc_map() with 3 parameters, 
while it's defined to have 4 parameters" in arch/x86/kernel/tboot.c etc.
Is the following chunk in patch "pte alloc trans splitting" necessary?

@@ -1167,16 +1168,18 @@ static inline void pgtable_page_dtor(struct page *page)
        pte_unmap(pte);                                 \
 } while (0)
 
-#define pte_alloc_map(mm, pmd, address)                        \
-       ((unlikely(!pmd_present(*(pmd))) && __pte_alloc(mm, pmd, address))? \
-               NULL: pte_offset_map(pmd, address))
+#define pte_alloc_map(mm, vma, pmd, address)                           \
+       ((unlikely(pmd_none(*(pmd))) && __pte_alloc(mm, vma,    \
+                                                       pmd, address))? \
+        NULL: pte_offset_map(pmd, address))
 
Thanks,
Naoya Horiguchi
