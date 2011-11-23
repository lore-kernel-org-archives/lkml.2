Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1KWGYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:24:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63126 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758504Ab1KWGYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:24:17 -0500
Date: Wed, 23 Nov 2011 15:24:05 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmscan: add task name to warn_scan_unevictable() messages
Message-ID: <20111123062405.GA25067@barrios-laptop.redhat.com>
References: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322027721-23677-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:55:20AM -0500, KOSAKI Motohiro wrote:
> If we need to know a usecase, caller program name is critical important.
> Show it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a1893c0..29d163e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3448,9 +3448,10 @@ void scan_mapping_unevictable_pages(struct address_space *mapping)
>  static void warn_scan_unevictable_pages(void)
>  {
>  	printk_once(KERN_WARNING
> -		    "The scan_unevictable_pages sysctl/node-interface has been "
> +		    "%s: The scan_unevictable_pages sysctl/node-interface has been "
>  		    "disabled for lack of a legitimate use case.  If you have "
> -		    "one, please send an email to linux-mm@kvack.org.\n");
> +		    "one, please send an email to linux-mm@kvack.org.\n",
> +		    current->comm);
>  }

Just nitpick:
How about using WARN_ONCE instead of custom warning?
It can show more exact call path as well as comm.
I guess it's more noticible to users.
Anyway, either is okay to me.

-- 
Kind regards,
Minchan Kim
