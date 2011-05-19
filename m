Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1ESDVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:21:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab1ESDVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tOSlkRsSfc1twmOz1v3xbyI1kMYQXID5ukvv5sPhlluPu/dIgQ+v+5RhPxZtg8qlmM
         mBnbLzFdqDBgyclbPYdA==
Date: Wed, 18 May 2011 20:21:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        Dave Hansen <dave@linux.vnet.ibm.com>, wdauchy@gmail.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V3 1/2] mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
 macro
In-Reply-To: <20110517213750.GB30232@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1105182019170.20651@chino.kir.corp.google.com>
References: <20110517213750.GB30232@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Daniel Kiper wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index d715200..217bcf6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -956,6 +956,9 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
>  #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
>  #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
>  
> +#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
> +#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
> +
>  struct page;
>  struct page_cgroup;
>  struct mem_section {

These seem useful.  Could you convert the code in drivers/base/node.c, 
mm/page_cgroup.c, mm/page_alloc.c, and mm/sparse.c that already do this to 
use the new macros?
