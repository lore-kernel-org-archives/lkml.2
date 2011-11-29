Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1K2AT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 19:19:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1K2AT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 19:19:28 -0500
Date: Tue, 29 Nov 2011 01:19:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, wli@holomorphy.com, david.woodhouse@intel.com,
        allen.m.kay@intel.com, mtosatti@redhat.com, chrisw@redhat.com,
        andi@firstfloor.org, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 1/2] thp: Add compound tail page _mapcount when mapped
Message-ID: <20111129001927.GO24062@one.firstfloor.org>
References: <1322200030-26350-1-git-send-email-youquan.song@intel.com> <20111128161626.e4be400a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128161626.e4be400a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +++ b/arch/x86/mm/gup.c
> > @@ -201,6 +201,8 @@ static noinline int gup_huge_pud(pud_t pud, unsigned long addr,
> >  	do {
> >  		VM_BUG_ON(compound_head(page) != head);
> >  		pages[*nr] = page;
> > +		if (PageTail(page))
> > +			get_huge_page_tail(page);
> >  		(*nr)++;
> >  		page++;
> >  		refs++;
> 
> Is the patch also applicable to 3.1.x?

I suspect it's broken since many kernels back, at least since THP 
was introduced, maybe earlier.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
