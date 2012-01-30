Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2A3TXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab2A3TXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:23:30 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] introduce thp_ptep_get()
Date: Mon, 30 Jan 2012 14:24:56 -0500
Message-Id: <1327951496-29186-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20120130152646.3f202259.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 03:26:46PM +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 27 Jan 2012 18:02:52 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Casting pmd into pte_t to handle thp is strongly architecture dependent.
> > This patch introduces a new function to separate this dependency from
> > independent part.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  arch/x86/include/asm/pgtable.h |    5 +++++
> >  fs/proc/task_mmu.c             |    4 ++--
> >  include/asm-generic/pgtable.h  |    4 ++++
> >  3 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git 3.3-rc1.orig/arch/x86/include/asm/pgtable.h 3.3-rc1/arch/x86/include/asm/pgtable.h
> > index 49afb3f..4cfcc7e 100644
> > --- 3.3-rc1.orig/arch/x86/include/asm/pgtable.h
> > +++ 3.3-rc1/arch/x86/include/asm/pgtable.h
> > @@ -165,6 +165,11 @@ static inline int has_transparent_hugepage(void)
> >  {
> >  	return cpu_has_pse;
> >  }
> > +
> > +static inline pte_t thp_ptep_get(pmd_t *pmd)
> > +{
> > +	return *(pte_t *)pmd;
> > +}
> 
> I'm sorry but I don't think the name is good. 
> (But I know my sense of naming is bad ;)

I named it from huge_ptep_get() defined for hugetlbfs.
But by my rethinking, it's bad naming.

> 
> How about pmd_to_pte_t ?

OK, it looks straightforward.
I'll take it if someone does not have better ideas.

> And, I wonder you can add error check as VM_BUG_ON(!pmd_trans_huge(*pmd));

Good, I'll add it.

Thank you, KAMEZAWA-san.
Naoya
