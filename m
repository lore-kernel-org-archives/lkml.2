Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2CFDQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:16:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55054 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2CFDQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:16:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minchan.kim@gmail.com designates 10.68.132.33 as permitted sender) smtp.mail=minchan.kim@gmail.com; dkim=pass header.i=minchan.kim@gmail.com
Date: Tue, 6 Mar 2012 12:16:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] page_alloc.c: Slightly improve the logic in
 __alloc_pages_high_priority
Message-ID: <20120306031619.GB14274@barrios>
References: <1330957105-3595-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330957105-3595-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kautuk,

On Mon, Mar 05, 2012 at 09:18:25AM -0500, Kautuk Consul wrote:
> The loop in __alloc_pages_high_priority() seems to be checking for
> (!page) and (gfp_mask & __GFP_NOFAIL) multiple times.
> 
> In fact, we don't really need to check (gfp_mask & __GFP_NOFAIL)
> for every iteration of the loop as the gfp_mask remains constant.
> 
> Slightly improve the logic in __alloc_pages_high_priority() to
> eliminate these multiple condition checks.

Thansk for your effort.

Surely we don't need mutliple condition check but it's not fast-path
and not a problem about readability. So I don't want to increase text
size unnecessary if it doesn't have a benefit.

barrios@barrios:~/linux-2.6$ size mm/page_alloc.o
   text	   data	    bss	    dec	    hex	filename
  32772	   1307	    576	  34655	   875f	mm/page_alloc.o
barrios@barrios:~/linux-2.6$ size mm/page_alloc.o.your_patch 
   text	   data	    bss	    dec	    hex	filename
  32804	   1307	    576	  34687	   877f	mm/page_alloc.o.patch
