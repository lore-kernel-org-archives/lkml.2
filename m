Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124Ab0EVAEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:04:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47153 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935098Ab0EVAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:04:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20100521115718.552d50dd.akpm@linux-foundation.org>
References: <20100521093629.1E44.A69D9226@jp.fujitsu.com> <20100521115718.552d50dd.akpm@linux-foundation.org>
Message-Id: <20100522085421.1E72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sat, 22 May 2010 09:04:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -static inline void lru_cache_add_active_anon(struct page *page)
> > -{
> > -	__lru_cache_add(page, LRU_ACTIVE_ANON);
> > -}
> > -
> >  static inline void lru_cache_add_file(struct page *page)
> >  {
> >  	__lru_cache_add(page, LRU_INACTIVE_FILE);
> >  }
> >  
> > -static inline void lru_cache_add_active_file(struct page *page)
> > -{
> > -	__lru_cache_add(page, LRU_ACTIVE_FILE);
> > -}
> 
> Did you intend to remove these two functions?

This is for applying Hannes's commnet.

> They do appear to be unused now, but they still make sense and might be
> used in the future, perhaps.  

Personally, I don't like the strategy that anyone without me might
use this function in the future. because It often never come.

> It's OK to remove them, but I'm wondering
> if it was deliberately included in this patch?

Makes sense.
OK, please drop current patch at once. I'll post V2.



