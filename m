Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0DTX3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:29:15 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:57952 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752045Ab0DTX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:29:13 -0400
Date: Wed, 21 Apr 2010 09:29:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
Message-ID: <20100420232904.GA23541@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <4BCD97C8.6090406@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCD97C8.6090406@rsk.demon.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:02:16PM +0100, Richard Kennedy wrote:
> On 20/04/10 03:41, Dave Chinner wrote:
> > This series contains the initial writeback tracing patches from
> > Jens, as well as the extensions I added to provide visibility into
> > writeback control structures as the are used by the writeback code.
> > The visibility given is sufficient to understand what is happening
> > in the writeback path - what path is writing data, what path is
> > blocking on congestion, etc, and to determine the differences in
> > behaviour for different sync modes and calling contexts. This
> > tracing really needs to be integrated into mainline so that anyone
> > can improve the tracing as they use it to track down problems
> > in our convoluted writeback paths.
> > 
> > The remaining patches are fixes to problems that the new tracing
> > highlighted.
> 
> Hi Dave,
> 
> Thanks for adding tracing to this, it will be really useful.
> 
> The fix to write_cache_pages looks really interesting, I'm going to test
> it on my machine. Maybe it should be a separate patch to get more
> visibility?

I don't see a big need to separate the series at this point. Once
there's been a review and testing we can decide how to push them
into mainline. IMO, the tracing is just as important as the bug
fixes....

> Ext4 also multiplies nr_to_write, so will that need fixing too?

No idea. I don't claim to understand ext4's convoluted delayed
allocation path and all it's constraints, so I guess you'd need to
ask the ext4 developers about that one. After all, with the tracing
they'd be able to see if there is a problem. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
