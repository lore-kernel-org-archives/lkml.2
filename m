Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab0KWFGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:06:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037Ab0KWFGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:06:08 -0500
Date: Mon, 22 Nov 2010 21:01:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
Message-Id: <20101122210132.be9962c7.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<20101122141449.9de58a2c.akpm@linux-foundation.org>
	<AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 13:52:05 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> >> +/*
> >> + * Function used to forecefully demote a page to the head of the inactive
> >> + * list.
> >> + */
> >
> > This comment is wrong? __The page gets moved to the _tail_ of the
> > inactive list?
> 
> No. I add it in _head_ of the inactive list intentionally.
> Why I don't add it to _tail_ is that I don't want to be aggressive.
> The page might be real working set. So I want to give a chance to
> activate it again.

Well..  why?  The user just tried to toss the page away altogether.  If
the kernel wasn't able to do that immediately, the best it can do is to
toss the page away asap?

> If it's not working set, it can be reclaimed easily and it can prevent
> active page demotion since inactive list size would be big enough for
> not calling shrink_active_list.

What is "working set"?  Mapped and unmapped pagecache, or are you
referring solely to mapped pagecache?

If it's mapped pagecache then the user was being a bit silly (or didn't
know that some other process had mapped the file).  In which case we
need to decide what to do - leave the page alone, deactivate it, or
half-deactivate it as this patch does.
