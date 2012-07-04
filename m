Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2GDBpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:45:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48577 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2GDBpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:45:30 -0400
Message-ID: <4FF39F0E.4070300@huawei.com>
Date: Wed, 4 Jul 2012 09:40:30 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] mm: setup pageblock_order before it's used by sparse
References: <1341047274-5616-1-git-send-email-jiang.liu@huawei.com> <20120703140705.af23d4d3.akpm@linux-foundation.org>
In-Reply-To: <20120703140705.af23d4d3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's a bit ugly calling set_pageblock_order() from both sparse_init()
> and from free_area_init_core().  Can we find a single place from which
> to call it?  It looks like here:
> 
> --- a/init/main.c~a
> +++ a/init/main.c
> @@ -514,6 +514,7 @@ asmlinkage void __init start_kernel(void
>  		   __stop___param - __start___param,
>  		   -1, -1, &unknown_bootoption);
>  
> +	set_pageblock_order();
>  	jump_label_init();
>  
>  	/*
> 
> would do the trick?
> 
> (free_area_init_core is __paging_init and set_pageblock_order() is
> __init.  I'm too lazy to work out if that's wrong)

Hi Andrew,
	Thanks for you comments. Yes, this's an issue. 
And we are trying to find a way to setup  pageorder_block as 
early as possible. Yinghai has suggested a good way for IA64,
but we still need help from PPC experts because PPC has the 
same issue and I'm not familiar with PPC architecture. 
We will submit another patch once we find an acceptable
solution here.
	Thanks!
	Gerry

