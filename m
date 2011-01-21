Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1AUDrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:47:17 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:21066 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab1AUDrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:47:16 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2011 22:47:15 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIaMOE15LN5m/2dsb2JhbACkYHS/HQ2FQwQ
Date: Fri, 21 Jan 2011 14:42:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit
 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
Message-ID: <20110121034208.GZ16267@dastard>
References: <87zkqvtet2.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zkqvtet2.fsf@sycorax.lbl.gov>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 02:01:45PM -0800, Alex Romosan wrote:
> my home directory is using xfs and i noticed that when i try to compile
> a program or do any kind of disk access (like git pull, etc) the amount
> of space used jumps by tens of gigabytes causing the disk to seemingly
> become full (eventually). on reboot the used disk space goes back to the
> correct value. i did a 'git bisect start -- fs/xfs' and i tracked it
> down to commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7. if i revert

When you quote a commit, can you please include the name of the
commit. e.g:

6e85756 ("xfs: don't truncate prealloc from frequently accessed inodes")

> this patch then disk usage doesn't increase unexpectedly (i have 270GB
> free and the disk became full by simply trying to compile wine). i can
> try patches if somebody comes up with one.

I don't think you tracked the problem down to the correct commit.
The previous commit:

055388a xfs: dynamic speculative EOF preallocation

Is the one with the known bug that causes excessive preallocation
when files are zero sized. The candidate fix is here:

http://oss.sgi.com/archives/xfs/2011-01/msg00281.html

Can you see if that solves your problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
