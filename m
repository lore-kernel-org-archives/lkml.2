Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0JHJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:57:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34769 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0JHJ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:56:59 -0400
Date: Fri, 8 Oct 2010 10:56:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008095658.GA19804@ZenIV.linux.org.uk>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-16-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:29PM +1100, Dave Chinner wrote:
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

FWIW, that one is begging to be split; what I mean is that there are
two classes of callers; ones that will set i_ino themselves anyway
and ones that really want i_ino invented.  Two functions?
