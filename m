Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2GGAi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2GGAi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:38:27 -0400
Date: Sat, 7 Jul 2012 09:38:19 +0900
From: Minchan Kim <minchan@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order
 0
Message-ID: <20120707003819.GA2041@barrios>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
 <20120706155920.GA7721@barrios>
 <CAAmzW4N+-xS65-NDJF2V9nzGDBTFC=20sZ8LJx5wCZ8=t7SpTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4N+-xS65-NDJF2V9nzGDBTFC=20sZ8LJx5wCZ8=t7SpTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 01:58:24AM +0900, JoonSoo Kim wrote:
> 2012/7/7 Minchan Kim <minchan@kernel.org>:
> > Hi Joonsoo,
> >
> > On Sat, Jul 07, 2012 at 12:28:41AM +0900, Joonsoo Kim wrote:
> >> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
> >
> > It's already slow path so it's pointless for such optimization.
> 
> I know this is so minor optimization.
> But why don't we do such a one?
> Is there any weak point?

Let's think about it.
You are adding *new rule* for minor optimization.
If new users uses __alloc_pages_direct_compact in future, they always have to
check whether order is zero not not. So it could increase code size as well as
bad for readbility. Even, I'm not sure adding branch is always win than
just passing the some arguement in all architecures.

> 
> >> And in almost invoking case, order is 0, so return immediately.
> >
> > You can't make sure it.
> 
> Okay.
> 
> >>
> >> Let's not invoke it when order 0
> >
> > Let's not ruin git blame.
> 
> Hmm...
> When I do git blame, I can't find anything related to this.

I mean if we merge the pointless patch, it could be showed firstly instead of
meaningful patch when we do git blame. It makes us bothering when we find blame-patch.

> 
> Thanks for comments

