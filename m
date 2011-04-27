Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1D0F0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 01:26:16 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:53020 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab1D0F0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 01:26:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYDABent015LHHJgWdsb2JhbAClaRUBARYmJcRZDoVoBJUwh1I
Date: Wed, 27 Apr 2011 15:26:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: drosenberg@vsecurity.com, ak@linux.intel.com, eugeneteo@kernel.org,
        aelder@sgi.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [8/106] xfs: prevent leaking uninitialized stack
 memory in FSGEOMETRY_V1
Message-ID: <20110427052610.GH12436@dastard>
References: <20110426212.641772347@firstfloor.org>
 <20110426211246.2E1863E1887@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426211246.2E1863E1887@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:12:46PM -0700, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> From: Dan Rosenberg <drosenberg@vsecurity.com>
> 
> commit c4d0c3b097f7584772316ee4d64a09fe0e4ddfca upstream.
> 
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
> 
> v2 switches to memset() to avoid future issues if structure members
> change, on suggestion of Dave Chinner.

Did you grab the followup patch that fixed the stack corruption
this change caused?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
