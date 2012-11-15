Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2KOIOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:14:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2KOIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:14:19 -0500
Date: Thu, 15 Nov 2012 00:14:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 03/11] thp: copy_huge_pmd(): copy huge zero page
In-Reply-To: <20121115080133.GA9676@otc-wbsnb-06>
Message-ID: <alpine.DEB.2.00.1211150013220.4410@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-4-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.00.1211141433150.13515@chino.kir.corp.google.com> <20121115080133.GA9676@otc-wbsnb-06>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Kirill A. Shutemov wrote:

> > > @@ -778,6 +790,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> > >  		pte_free(dst_mm, pgtable);
> > >  		goto out_unlock;
> > >  	}
> > > +	if (is_huge_zero_pmd(pmd)) {
> > > +		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd);
> > > +		ret = 0;
> > > +		goto out_unlock;
> > > +	}
> > 
> > You said in the introduction message in this series that you still allow 
> > splitting of the pmd, so why no check for pmd_trans_splitting() before 
> > this?
> 
> pmd_trans_splitting() returns true only for pmd which points to a page
> under spliiting. It never happens with huge zero page.
> We only split a pmd to a page table without touching the page.
> mm->page_table_lock is enough to protect against that.
> 

Comment in the code?
