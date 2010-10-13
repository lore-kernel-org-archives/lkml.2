Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0JMFJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:09:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48041 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0JMFJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:09:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] fix return value of scan_lru_pages in memory unplug
Cc: kosaki.motohiro@jp.fujitsu.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
In-Reply-To: <20101013135903.c505ff8b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101013135903.c505ff8b.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20101013140841.ADBA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Oct 2010 14:08:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC'ed to stable tree...maybe all kernel has this bug.
> But this may not very critical because we've got no report until now.

Thanks.


> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> scan_lru_pages returns pfn. So, it's type should be "unsigned long"
> not "int".
> 
> Note: I guess this has been work until now because memory hotplug tester's
>       machine has not very big memory....
>       physical address < 32bit << PAGE_SHIFT.
> 
> Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memory_hotplug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: mmotm-1008/mm/memory_hotplug.c
> ===================================================================
> --- mmotm-1008.orig/mm/memory_hotplug.c
> +++ mmotm-1008/mm/memory_hotplug.c
> @@ -646,7 +646,7 @@ static int test_pages_in_a_zone(unsigned
>   * Scanning pfn is much easier than scanning lru list.
>   * Scan pfn from start to end and Find LRU page.
>   */
> -int scan_lru_pages(unsigned long start, unsigned long end)
> +unsigned long scan_lru_pages(unsigned long start, unsigned long end)

Also, this can be static. anyway
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




