Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0D1NpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:45:14 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:45128 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089Ab0D1NpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:45:12 -0400
Date: Wed, 28 Apr 2010 23:45:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100428134502.GI9783@dastard>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
 <1271118255-21070-2-git-send-email-david@fromorbit.com>
 <4BD80260.3050501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD80260.3050501@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 12:39:44PM +0300, Avi Kivity wrote:
> On 04/13/2010 03:24 AM, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >The current shrinker implementation requires the registered callback
> >to have global state to work from. This makes it difficult to shrink
> >caches that are not global (e.g. per-filesystem caches). Add a
> >context argument to the shrinker callback so that it can easily be
> >used in such situations.
> 
> >@@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
> >   * querying the cache size, so a fastpath for that case is appropriate.
> >   */
> >  struct shrinker {
> >-	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> >+	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> >+	void *ctx;	/* user callback context */
> >  	int seeks;	/* seeks to recreate an obj */
> 
> 
> It's nicer (and slightly cheaper) to have
> 
>   int (*shrink)(struct shrinker *shrinker, int nr_to_scan, gfp_t gfp_mask);
>   /* no void *ctx; */
> 
> Clients can use container_of() to reach their context from the
> shrinker argument.

Agreed, that makes a lot of sense. I'll change it for the next version.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
