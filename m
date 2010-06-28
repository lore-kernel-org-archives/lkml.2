Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0F1TMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:12:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab0F1TL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:11:59 -0400
Date: Mon, 28 Jun 2010 12:10:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [Patch] Call cond_resched() at bottom of main look in 
 balance_pgdat()
Message-Id: <20100628121056.408cbca2.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin-dYU245QH3WJWzLAx713o0pJLYozRO6tin3rq@mail.gmail.com>
References: <20100622112416.B554.A69D9226@jp.fujitsu.com>
	<AANLkTilN3EcYq400ajA2-rf3Xs4MhD-sKCg44fjzKlX1@mail.gmail.com>
	<20100622114739.B563.A69D9226@jp.fujitsu.com>
	<AANLkTimleJIOdYquPwJvgGK3Dj_JDijoNjCQh4dfXxAY@mail.gmail.com>
	<20100622213301.GA26285@cmpxchg.org>
	<AANLkTin-dYU245QH3WJWzLAx713o0pJLYozRO6tin3rq@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 08:07:34 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

The patch is a bit sucky, isn't it?

a) the cond_resched() which Larry's patch adds is very special.  It
   _looks_ like a random preemption point but it's actually critical to
   the correct functioning of the system.  That's utterly unobvious to
   anyone who reads the code, so a comment explaining this *must* be
   included.

b) cond_resched() is a really crappy way of solving the problem
   which Larry described.  It will sit there chewing away CPU time
   until kswapd's timeslice expires.

I suppose we can live with b) although it _does_ suck and I'd suggest
that the comment include a big FIXME, so someone might fix it.

Larry, please fix a), gather the acks and reviewed-by's, update the
changelog to identify the commit which broke it and resend?

