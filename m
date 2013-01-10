Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab3AJAUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:20:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3AJAUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:20:44 -0500
Date: Wed, 9 Jan 2013 16:20:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Sonny Rao <sonnyrao@google.com>, Bryan Freed <bfreed@google.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: prevent to add a page to swap if may_writepage
 is unset
Message-Id: <20130109162042.79a9fedd.akpm@linux-foundation.org>
In-Reply-To: <1357712474-27595-2-git-send-email-minchan@kernel.org>
References: <1357712474-27595-1-git-send-email-minchan@kernel.org>
	<1357712474-27595-2-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Jan 2013 15:21:13 +0900
Minchan Kim <minchan@kernel.org> wrote:

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -780,6 +780,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		if (PageAnon(page) && !PageSwapCache(page)) {
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
> +			if (!sc->may_writepage)
> +				goto keep_locked;
>  			if (!add_to_swap(page))
>  				goto activate_locked;
>  			may_enter_fs = 1;

We should add a comment here explaining what's going on.  But I can't
suggest anything which sounds rational because this looks so wrong :(

