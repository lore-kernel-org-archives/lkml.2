Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab2LFC6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:58:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2LFC6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:58:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,227,1355068800"; 
   d="scan'208";a="6342046"
Message-ID: <50C00982.6020601@cn.fujitsu.com>
Date: Thu, 06 Dec 2012 10:57:06 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 4/5] page_alloc: Make movablecore_map has higher priority
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-5-git-send-email-tangchen@cn.fujitsu.com> <50BF6BA0.8060505@gmail.com> <50BFF443.3090504@cn.fujitsu.com> <50C00259.50901@huawei.com> <50C0081A.308@huawei.com>
In-Reply-To: <50C0081A.308@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/06 10:57:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/06 10:57:24,
	Serialize complete at 2012/12/06 10:57:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu, Wu,

I got it, thank you very much. The idea is very helpful. :)
I'll apply your patches and do some tests later.

Thanks. :)


On 12/06/2012 10:51 AM, Jianguo Wu wrote:
> Hi Tang,
>
> There is a bug in Gerry's patch, please apply this patch to fix it.
>
> ---
>   mm/page_alloc.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 41c3b51..d981810 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4383,7 +4383,7 @@ static int __init find_zone_movable_from_movablecore_map(void)
>   			 */
>   			start_pfn = max(start_pfn,
>   					movablecore_map.map[map_pos].start);
> -			zone_movable_pfn[nid] = roundup(zone_movable_pfn[nid],
> +			zone_movable_pfn[nid] = roundup(start_pfn,
>   							MAX_ORDER_NR_PAGES);
>   			break;
>   		}

