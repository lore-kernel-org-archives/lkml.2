Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2CMFtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:49:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55488 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab2CMFtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:49:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Mar 2012 14:47:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] memcg: avoid THP split in task migration
Message-Id: <20120313144736.e4a39634.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1331591456-20769-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1331591456-20769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1331591456-20769-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 18:30:56 -0400
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently we can't do task migration among memory cgroups without THP split,
> which means processes heavily using THP experience large overhead in task
> migration. This patch introduces the code for moving charge of THP and makes
> THP more valuable.
> 
> Changes from v3:
> - use enum mc_target_type and MC_TARGET_* explicitly
> - replace lengthy name is_target_thp_for_mc() with get_mctgt_type_thp()
> - drop cond_resched()
> - drop mapcount check of page sharing (Hugh and KAMEZAWA-san are preparing
>   patches to change the behavior of moving charge of shared pages, so this
>   patch keeps up with the change to avoid potential conflict.)
> 
> Changes from v2:
> - add move_anon() and mapcount check
> 
> Changes from v1:
> - rename is_target_huge_pmd_for_mc() to is_target_thp_for_mc()
> - remove pmd_present() check (it's buggy when pmd_trans_huge(pmd) is true)
> - is_target_thp_for_mc() calls get_page() only when checks are passed
> - unlock page table lock if !mc.precharge
> - compare return value of is_target_thp_for_mc() explicitly to MC_TARGET_TYPE
> - clean up &walk->mm->page_table_lock to &vma->vm_mm->page_table_lock
> - add comment about why race with split_huge_page() does not happen
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Hillf Danton <dhillf@gmail.com>

Thank you.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


