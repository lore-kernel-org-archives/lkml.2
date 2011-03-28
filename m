Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1C1Wqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:46:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1C1Wqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=WoVVsGigOyWxml9IWfCYoNtNo7VE5qWTOtdvIOr0Ee51SToYPTtFEyaWQyRMIl8Phr
         eKsQHjkeHiirr7OIGCJA==
Date: Mon, 28 Mar 2011 15:46:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN()
 macro
In-Reply-To: <20110328092412.GC13826@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1103281545220.7148@chino.kir.corp.google.com>
References: <20110328092412.GC13826@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Daniel Kiper wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 02ecb01..d342820 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -931,6 +931,9 @@ static inline unsigned long early_pfn_to_nid(unsigned long pfn)
>  #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
>  #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
>  
> +#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
> +#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
> +
>  #ifdef CONFIG_SPARSEMEM
>  
>  /*

These are only valid for CONFIG_SPARSEMEM, so they need to be defined 
conditionally.
