Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0JUWcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:32:39 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:42881 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751534Ab0JUWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:32:37 -0400
Date: Fri, 22 Oct 2010 09:32:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/21] fs: rework icount to be a locked variable
Message-ID: <20101021223234.GT32255@dastard>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-9-git-send-email-david@fromorbit.com>
 <20101021194044.GC19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021194044.GC19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 08:40:45PM +0100, Al Viro wrote:
> On Thu, Oct 21, 2010 at 11:49:33AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The inode reference count is currently an atomic variable so that it
> > can be sampled/modified outside the inode_lock. However, the
> > inode_lock is still needed to synchronise the final reference count
> > and checks against the inode state.
> > 
> > To avoid needing the protection of the inode lock, protect the inode
> > reference count with the per-inode i_lock and convert it to a normal
> > variable. To avoid existing out-of-tree code accidentally compiling
> > against the new method, rename the i_count field to i_ref. This is
> > relatively straight forward as there are limited external references
> > to the i_count field remaining.
> 
> BTW, the same thing as with Nick's set - separate patch for "clone the
> reference to inode we are already holding" helper, in front of queue.

Isn't that already done by the patch 6 "fs: Clean up inode reference
counting"? That patch does the converting of stand-alone
atomic_inc(&inode->i-count) into iref(inode), not this one.
Maybe I've misunderstood what you are wanting to be changed with
this patch - can you clarify, Al?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
