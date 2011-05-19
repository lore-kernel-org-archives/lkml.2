Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab1EST6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:58:20 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:58770 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab1EST6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:58:19 -0400
Date: Thu, 19 May 2011 21:56:53 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        Dave Hansen <dave@linux.vnet.ibm.com>, wdauchy@gmail.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V3 1/2] mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
Message-ID: <20110519195653.GC27202@router-fw-old.local.net-space.pl>
References: <20110517213750.GB30232@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105182019170.20651@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105182019170.20651@chino.kir.corp.google.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 08:21:23PM -0700, David Rientjes wrote:
> On Tue, 17 May 2011, Daniel Kiper wrote:
>
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index d715200..217bcf6 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -956,6 +956,9 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
> >  #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
> >  #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
> >
> > +#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
> > +#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
> > +
> >  struct page;
> >  struct page_cgroup;
> >  struct mem_section {
>
> These seem useful.  Could you convert the code in drivers/base/node.c,
> mm/page_cgroup.c, mm/page_alloc.c, and mm/sparse.c that already do this to
> use the new macros?

No problem. I do that in next week or two.

Daniel
