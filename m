Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0LPPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:36:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0LPPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:36:38 -0500
Date: Thu, 16 Dec 2010 10:36:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Message-ID: <20101216153634.GA24185@infradead.org>
References: <1292203313-15570-1-git-send-email-david@fromorbit.com>
 <1292203313-15570-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292203313-15570-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:21:52PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has a per-cpu counter implementation for in-core superblock
> counters that pre-dated the generic implementation. It is complex
> and baroque as it is tailored directly to the needs of ENOSPC
> detection.
> 
> Now that the generic percpu counter infrastructure has the
> percpu_counter_add_unless_lt() function that implements the
> necessary threshold checks for us, switch the XFS per-cpu
> superblock counters to use the generic percpu counter
> infrastructure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

A little nipick:

> -#ifdef HAVE_PERCPU_SB
>  	ASSERT(field < XFS_SBS_ICOUNT || field > XFS_SBS_FDBLOCKS);
> -#endif

No need to keep this assert - xfs_mod_incore_sb_unlocked already
has one for unknown fields.

