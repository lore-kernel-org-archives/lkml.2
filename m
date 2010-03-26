Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0CZDHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:07:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33694 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0CZDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:07:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100325133936.GR2024@csn.ul.ie>
References: <20100325191229.8e3d2ba1.kamezawa.hiroyu@jp.fujitsu.com> <20100325133936.GR2024@csn.ul.ie>
Message-Id: <20100326120429.6C98.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 26 Mar 2010 12:07:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

very small nit

> There were minor changes in how the rcu_read_lock is taken and released
> based on other comments. With your suggestion, the block now looks like;
> 
>         if (PageAnon(page)) {
>                 rcu_read_lock();
>                 rcu_locked = 1;
> 
>                 /*
>                  * If the page has no mappings any more, just bail. An
>                  * unmapped anon page is likely to be freed soon but
>                  * worse,
>                  * it's possible its anon_vma disappeared between when
>                  * the page was isolated and when we reached here while
>                  * the RCU lock was not held
>                  */
>                 if (!page_mapcount(page) && !PageSwapCache(page))

                        page_mapped?

>                         goto rcu_unlock;
> 
>                 anon_vma = page_anon_vma(page);
>                 atomic_inc(&anon_vma->external_refcount);
>         }



