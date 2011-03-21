Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1CVAEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:04:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42626 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1CVAE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:04:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 22 Mar 2011 08:57:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] memcg: mark init_section_page_cgroup() properly
Message-Id: <20110322085755.c4193fc1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 21:54:13 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> The commit ca371c0d7e23 ("memcg: fix page_cgroup fatal error
> in FLATMEM") removes call to alloc_bootmem() in the function
> so that it can be marked as __meminit to reduce memory usage
> when MEMORY_HOTPLUG=n.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/page_cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 5bffada7cde1..2d1a0fa01d7b 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -105,8 +105,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	return section->page_cgroup + pfn;
>  }
>  
> -/* __alloc_bootmem...() is protected by !slab_available() */
> -static int __init_refok init_section_page_cgroup(unsigned long pfn)
> +static int __meminit init_section_page_cgroup(unsigned long pfn)
>  {
>  	struct mem_section *section = __pfn_to_section(pfn);
>  	struct page_cgroup *base, *pc;
> -- 
> 1.7.4
> 
> 

