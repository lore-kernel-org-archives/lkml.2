Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2KHJQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:16:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4735 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab2KHJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:16:43 -0500
X-IronPort-AV: E=Sophos;i="4.80,737,1344182400"; 
   d="scan'208";a="6161222"
Message-ID: <509B79DB.1010208@cn.fujitsu.com>
Date: Thu, 08 Nov 2012 17:22:35 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        lai jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v2] memory-hotplug: fix NR_FREE_PAGES mismatch's fix
References: <509B75FF.6070806@cn.fujitsu.com>
In-Reply-To: <509B75FF.6070806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 17:16:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/08 17:16:43,
	Serialize complete at 2012/11/08 17:16:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/08/2012 05:06 PM, Wen Congyang Wrote:
> 
> When a page is freed and put into pcp list, get_freepage_migratetype()
> doesn't return MIGRATE_ISOLATE even if this pageblock is isolated.
> So we should use get_freepage_migratetype() instead of mt to check
> whether it is isolated.

In my local tree, there are some patches from isimatu, so I don't add
-s option when generating the patch. So I forgot to add:

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Reported-by: Jianguo Wu <wujianguo106@gmail.com>


> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 027afd0..795875f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -667,7 +667,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
>  			__free_one_page(page, zone, 0, mt);
>  			trace_mm_page_pcpu_drain(page, 0, mt);
> -			if (likely(mt != MIGRATE_ISOLATE)) {
> +			if (likely(get_pageblock_migratetype(page) != MIGRATE_ISOLATE)) {
>  				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
>  				if (is_migrate_cma(mt))
>  					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);

