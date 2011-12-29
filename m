Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1L2RVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:21:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58913 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1L2RVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:21:41 -0500
Message-ID: <4EFCA1A1.70507@gmail.com>
Date: Thu, 29 Dec 2011 12:21:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: fix typo in isolating lru pages
References: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
In-Reply-To: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/29/11 7:38 AM), Hillf Danton wrote:
> It is not the tag page but the cursor page that we should process, and it looks
> a typo.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> Cc: Michal Hocko<mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton<akpm@linux-foundation.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Hugh Dickins<hughd@google.com>
> ---
>
> --- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
> +++ b/mm/vmscan.c	Thu Dec 29 20:23:30 2011
> @@ -1231,13 +1231,13 @@ static unsigned long isolate_lru_pages(u
>
>   				mem_cgroup_lru_del(cursor_page);
>   				list_move(&cursor_page->lru, dst);
> -				isolated_pages = hpage_nr_pages(page);
> +				isolated_pages = hpage_nr_pages(cursor_page);
>   				nr_taken += isolated_pages;
>   				nr_lumpy_taken += isolated_pages;
>   				if (PageDirty(cursor_page))
>   					nr_lumpy_dirty += isolated_pages;
>   				scan++;
> -				pfn += isolated_pages-1;
> +				pfn += isolated_pages - 1;
>   			} else {
>   				/*
>   				 * Check if the page is freed already.

Looks correct.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


