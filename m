Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2CHFud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:50:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50874 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2CHFub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:50:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 14:48:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mapcount check in move charge code for
 anonymous page
Message-Id: <20120308144855.271ed829.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1330720508-21019-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1330720508-21019-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Mar 2012 15:35:08 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently charge on shared anonyous pages is supposed not to moved
> in task migration. To implement this, we need to check that mapcount > 1,
> instread of > 2. So this patch fixes it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Hm. I don't remember why this check uses mapcount > 2...maybe bug.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
> index b6d1bab..785f6d3 100644
> --- linux-next-20120228.orig/mm/memcontrol.c
> +++ linux-next-20120228/mm/memcontrol.c
> @@ -5102,7 +5102,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
>  		return NULL;
>  	if (PageAnon(page)) {
>  		/* we don't move shared anon */
> -		if (!move_anon() || page_mapcount(page) > 2)
> +		if (!move_anon() || page_mapcount(page) > 1)
>  			return NULL;
>  	} else if (!move_file())
>  		/* we ignore mapcount for file pages */
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

