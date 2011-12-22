Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1LVAZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:25:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1LVAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:25:20 -0500
Date: Wed, 21 Dec 2011 16:25:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mempool: drop unnecessary and incorrect BUG_ON()
 from mempool_destroy()
Message-Id: <20111221162519.b7fc3a79.akpm@linux-foundation.org>
In-Reply-To: <20111222001800.GL9213@google.com>
References: <20111222001800.GL9213@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 16:18:00 -0800
Tejun Heo <tj@kernel.org> wrote:

> mempool_destroy() is a thin wrapper around free_pool().  The only
> thing it adds is BUG_ON(pool->curr_nr != pool->min_nr).  The intention
> seems to be to enforce that all allocated elements are freed; however,
> the BUG_ON() can't achieve that (it doesn't know anything about
> objects above min_nr) and incorrect as mempool_resize() is allowed to
> leave the pool extended but not filled.  Furthermore, panicking is way
> worse than any memory leak and there are better debug tools to track
> memory leaks.
> 
> Drop the BUG_ON() from mempool_destory() and as that leaves the
> function identical to free_pool(), replace it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@kernel.org

(that's stable@vger.kernel.org)

> ---
> These patches are on top of "mempool: fix and document synchronization
> and memory barrier usage" patch[1].  Both are fixes and it probably is
> a good idea to forward to -stable.

I'm not sure that either of these are suitable for -stable.  There's no
demonstrated problem, nor even a likely theoretical one, is there?

If we do decide to backport, I don't think the -stable guys will want
the large-but-nice comment-adding patch so both these patches would need to
be reworked for -stable usage.  The first patch does apply successfully
to mainline.  The second does not.

