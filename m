Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1LVBcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:32:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48197 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1LVBcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:32:13 -0500
Date: Wed, 21 Dec 2011 17:31:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222013156.GQ9213@google.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
 <20111222004629.GO9213@google.com>
 <20111221170919.f7d49fc6.akpm@linux-foundation.org>
 <20111222012312.GP9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222012312.GP9213@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 05:23:12PM -0800, Tejun Heo wrote:
> I see.  It just seemed like a weird behavior and looking at the commit
> log, there was originally code to kick reclaim there, so the sequence
> made sense - first try w/o reclaim, look at the mempool, kick reclaim
> and retry w/ GFP_WAIT and then wait for someone else to free.  That
> part was removed by 20a77776c24 "[PATCH] mempool: simplify alloc" back
> in 05.  In the process, it also lost retry w/ reclaim before waiting
> for mempool reserves.

Oops, it isn't that relevant but the original code retried w/ reclaim
before looking at mempool if less than half were left in the pool.

-- 
tejun
