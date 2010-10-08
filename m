Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0JHIWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:22:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48919 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab0JHIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:22:36 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
	<1286515292-15882-16-git-send-email-david@fromorbit.com>
Date: Fri, 08 Oct 2010 10:22:34 +0200
In-Reply-To: <1286515292-15882-16-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Fri, 8 Oct 2010 16:21:29 +1100")
Message-ID: <87d3rl5c1h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> From: Eric Dumazet <eric.dumazet@gmail.com>
>
> new_inode() dirties a contended cache line to get increasing
> inode numbers. This limits performance on workloads that cause
> significant parallel inode allocation.
>
> Solve this problem by using a per_cpu variable fed by the shared
> last_ino in batches of 1024 allocations.  This reduces contention on
> the shared last_ino, and give same spreading ino numbers than before
> (i.e. same wraparound after 2^32 allocations).

This doesn't help for Unix disk file systems, so not fully sure why you
need it for XFS.

But looks reasonable, although it would be better to simply fix 
sockets/pipes/etc. to not allocate an inode numbers.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
