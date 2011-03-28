Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1C1Plt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:41:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54888 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab1C1Pls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:41:48 -0400
Subject: Re: [PATCH 2/3] mm: Add SECTION_ALIGN_UP() and
 SECTION_ALIGN_DOWN() macro
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110328092412.GC13826@router-fw-old.local.net-space.pl>
References: <20110328092412.GC13826@router-fw-old.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 28 Mar 2011 08:41:24 -0700
Message-ID: <1301326884.31700.8321.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 11:24 +0200, Daniel Kiper wrote:
> Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro which aligns
> given pfn to upper section and lower section boundary accordingly.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  include/linux/mmzone.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
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

There are certainly a lot of different ways to do this, including using
the existing ALIGN() macro, but you won't be the first to open-code
it. :)

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

