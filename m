Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636Ab2FUXqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:46:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759812Ab2FUXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:46:09 -0400
Date: Thu, 21 Jun 2012 16:46:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 3.5-rc3] mm, mempolicy: fix mbind() to do synchronous
 migration
Message-Id: <20120621164606.4ae1a71d.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1206201758500.3068@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 18:00:12 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> If the range passed to mbind() is not allocated on nodes set in the
> nodemask, it migrates the pages to respect the constraint.
> 
> The final formal of migrate_pages() is a mode of type enum migrate_mode,
> not a boolean.  do_mbind() is currently passing "true" which is the
> equivalent of MIGRATE_SYNC_LIGHT.  This should instead be MIGRATE_SYNC
> for synchronous page migration.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/mempolicy.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1177,7 +1177,7 @@ static long do_mbind(unsigned long start, unsigned long len,
>  		if (!list_empty(&pagelist)) {
>  			nr_failed = migrate_pages(&pagelist, new_vma_page,
>  						(unsigned long)vma,
> -						false, true);
> +						false, MIGRATE_SYNC);
>  			if (nr_failed)
>  				putback_lru_pages(&pagelist);
>  		}

I can't really do anything with this patch - it's a bug added by
Peter's "mm/mpol: Simplify do_mbind()" and added to linux-next via one
of Ingo's trees.

And I can't cleanly take the patch over as it's all bound up with the
other changes for sched/numa balancing.

Is that patchset actually going anywhere in the short term in its
present form?  If not, methinks it would be better to pull it out of
-next for now.

