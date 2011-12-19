Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1LSSkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:40:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1LSSkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:40:51 -0500
Date: Mon, 19 Dec 2011 19:40:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
Message-ID: <20111219184047.GA5637@one.firstfloor.org>
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git 3.2-rc5.orig/fs/proc/page.c 3.2-rc5/fs/proc/page.c
> index 6d8e6a9..d436fc6 100644
> --- 3.2-rc5.orig/fs/proc/page.c
> +++ 3.2-rc5/fs/proc/page.c
> @@ -116,6 +116,11 @@ u64 stable_page_flags(struct page *page)
>  	if (PageHuge(page))
>  		u |= 1 << KPF_HUGE;
>  
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (PageTransCompound(page))
> +		u |= 1 << KPF_THP;
> +#endif

It would be better to have PageTransCompound be a dummy (always 0) 
for !CONFIG_TRANSPARENT_HUGEPAGE and KPF_THP always defined.
This would keep ifdefery in the headers.

-Andi
