Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2JWKI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:08:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51663 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab2JWKI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:08:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6051900"
Message-ID: <50866E04.4040005@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 18:14:28 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: make zone_pcp_reset independ on MEMORY_HOTREMOVE
References: <1350985047-23148-1-git-send-email-mhocko@suse.cz>
In-Reply-To: <1350985047-23148-1-git-send-email-mhocko@suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:08:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 18:08:23,
	Serialize complete at 2012/10/23 18:08:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/23/2012 05:37 PM, Michal Hocko Wrote:
> 340175b7 (mm/hotplug: free zone->pageset when a zone becomes empty)
> introduced zone_pcp_reset and hided it inside CONFIG_MEMORY_HOTREMOVE.
> The function is since 506e5fb7 (memory-hotplug: allocate zone's pcp
> before onlining pages) called also called from online_pages which

This patch is still in -mm tree, and I have received a report from
Liu Yuanhan.

> is called outside CONFIG_MEMORY_HOTREMOVE which causes a linkage error.
> 
> The function, although not used outside of MEMORY_{HOTPLUT,HOTREMOVE},
> seems like universal enough so let's keep it at its current location
> and only remove the HOTREMOVE guard.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e29912e..30e359c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5981,7 +5981,6 @@ void __meminit zone_pcp_update(struct zone *zone)
>  }
>  #endif
>  
> -#ifdef CONFIG_MEMORY_HOTREMOVE
>  void zone_pcp_reset(struct zone *zone)
>  {
>  	unsigned long flags;
> @@ -6001,6 +6000,7 @@ void zone_pcp_reset(struct zone *zone)
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_MEMORY_HOTREMOVE
>  /*
>   * All pages in the range must be isolated before calling this.
>   */

This patch looks find to me.

Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>

