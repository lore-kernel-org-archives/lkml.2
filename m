Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2I0BVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:21:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:45524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2I0BVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:21:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,492,1344236400"; 
   d="scan'208";a="227069016"
Date: Thu, 27 Sep 2012 09:20:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] kpageflags: fix wrong KPF_THP on non-huge compound
 pages
Message-ID: <20120927012057.GE7205@localhost>
References: <1348691234-31729-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348691234-31729-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	else if (PageTransCompound(page))
> +	/*
> +	 * PageTransCompound can be true for non-huge compound pages (slab
> +	 * pages or pages allocated by drivers with __GFP_COMP) because it
> +	 * just checks PG_head/PG_tail, so we need to check PageLRU to make
> +	 * sure a given page is a thp, not a non-huge compound page.
> +	 */
> +	else if (PageTransCompound(page) && PageLRU(compound_trans_head(page)))
>  		u |= 1 << KPF_THP;

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks!
