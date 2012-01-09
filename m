Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2AIQtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:49:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47883 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab2AIQtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBAMtT04n8p4ht4oCSOYKVcUcG0-hbSvmjrP-yhwBYhU1A@mail.gmail.com>
References: <CAJd=RBAMtT04n8p4ht4oCSOYKVcUcG0-hbSvmjrP-yhwBYhU1A@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 9 Jan 2012 11:49:14 -0500
Message-ID: <CAHGf_=ovR8Mwagaa2PpjEfjKpuqjvPdWX5Uy=Tyi2+B480WUBA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: recompute page status when putting back
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If unlikely the given page is isolated from lru list again, its status is
> recomputed before putting back to lru list, since the comment says page's
> status can change while we move it among lru.
>
>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/mm/vmscan.c       Thu Dec 29 20:20:16 2011
> +++ b/mm/vmscan.c       Fri Jan  6 21:31:56 2012
> @@ -633,12 +633,14 @@ int remove_mapping(struct address_space
>  void putback_lru_page(struct page *page)
>  {
>        int lru;
> -       int active = !!TestClearPageActive(page);
> -       int was_unevictable = PageUnevictable(page);
> +       int active;
> +       int was_unevictable;
>
>        VM_BUG_ON(PageLRU(page));
>
>  redo:
> +       active = !!TestClearPageActive(page);
> +       was_unevictable = PageUnevictable(page);
>        ClearPageUnevictable(page);

When and How do this race happen?
