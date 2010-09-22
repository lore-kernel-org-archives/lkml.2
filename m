Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab0IVFBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 01:01:44 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40673 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0IVFBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 01:01:42 -0400
Date: Wed, 22 Sep 2010 13:59:07 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] hugetlb: hugepage migration core
Message-ID: <20100922045907.GC2538@spritzera.linux.bs1.fc.nec.co.jp>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1283908781-13810-5-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20100920111054.GJ1998@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20100920111054.GJ1998@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:10:55PM +0100, Mel Gorman wrote:
> On Wed, Sep 08, 2010 at 10:19:35AM +0900, Naoya Horiguchi wrote:
...
> > @@ -95,26 +96,34 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
> >  	pte_t *ptep, pte;
> >   	spinlock_t *ptl;
> >  
> > - 	pgd = pgd_offset(mm, addr);
> > -	if (!pgd_present(*pgd))
> > -		goto out;
> > +	if (unlikely(PageHuge(new))) {
> > +		ptep = huge_pte_offset(mm, addr);
> > +		if (!ptep)
> > +			goto out;
> > +		ptl = &mm->page_table_lock;
> > +	} else {
> > +		pgd = pgd_offset(mm, addr);
> > +		if (!pgd_present(*pgd))
> > +			goto out;
> >  
> > -	pud = pud_offset(pgd, addr);
> > -	if (!pud_present(*pud))
> > -		goto out;
> > +		pud = pud_offset(pgd, addr);
> > +		if (!pud_present(*pud))
> > +			goto out;
> >  
> 
> Why are the changes to teh rest of the walkers necessary? Instead, why
> did you not identify which PTL lock you needed and then goto the point
> where spin_lock(ptl) is called? Similar to what page_check_address()
> does for example.

This is because Andi-san commented to avoid using goto sentense.
But honestly I'm not sure which is a clear way.

Thanks,
Naoya Horiguchi
