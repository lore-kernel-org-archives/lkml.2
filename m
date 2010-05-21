Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0EVAeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:34:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932767Ab0EVAeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:34:09 -0400
Date: Fri, 21 May 2010 17:32:15 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at
 first
Message-Id: <20100521173215.e2240f5b.akpm@linux-foundation.org>
In-Reply-To: <20100522085421.1E72.A69D9226@jp.fujitsu.com>
References: <20100521093629.1E44.A69D9226@jp.fujitsu.com>
	<20100521115718.552d50dd.akpm@linux-foundation.org>
	<20100522085421.1E72.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 09:04:30 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > > -static inline void lru_cache_add_active_anon(struct page *page)
> > > -{
> > > -	__lru_cache_add(page, LRU_ACTIVE_ANON);
> > > -}
> > > -
> > >  static inline void lru_cache_add_file(struct page *page)
> > >  {
> > >  	__lru_cache_add(page, LRU_INACTIVE_FILE);
> > >  }
> > >  
> > > -static inline void lru_cache_add_active_file(struct page *page)
> > > -{
> > > -	__lru_cache_add(page, LRU_ACTIVE_FILE);
> > > -}
> > 
> > Did you intend to remove these two functions?
> 
> This is for applying Hannes's commnet.
> 
> > They do appear to be unused now, but they still make sense and might be
> > used in the future, perhaps.  
> 
> Personally, I don't like the strategy that anyone without me might
> use this function in the future. because It often never come.
> 
> > It's OK to remove them, but I'm wondering
> > if it was deliberately included in this patch?
> 
> Makes sense.
> OK, please drop current patch at once. I'll post V2.

Is OK, let's keep the change.  I just wanted to check that it wasn't
made accidentally.  
