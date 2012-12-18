Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2LRVPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:15:00 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:37902 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab2LRVOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:14:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAM7b0FB5LGZj/2dsb2JhbABFhVKyVYQAgX4Xc4IeAQEEATocIxAIAw4DAwECAS4UDRgDEw4TiAEDCQWubg2JVRSLTGmDYmEDlDSBVYs4hRGDCA
Date: Wed, 19 Dec 2012 08:14:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: ys <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: update atimes over one day in the past or future
Message-ID: <20121218211451.GE15182@dastard>
References: <50CC9663.4010200@gmail.com>
 <20121216021508.GG9806@dastard>
 <60E209F1-F797-42C2-9F41-43BF7839B2A3@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60E209F1-F797-42C2-9F41-43BF7839B2A3@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 05:14:57AM -0700, Andreas Dilger wrote:
> On 2012-12-15, at 19:15, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Sat, Dec 15, 2012 at 11:25:23PM +0800, ys wrote:
> >> From 3d56c131b58a21c05bcd677b9d2ba915abcbf195 Mon Sep 17 00:00:00 2001
> >> From: yangsheng <sickamd@gmail.com>
> >> Date: Sat, 15 Dec 2012 21:46:22 +0800
> >> Subject: [PATCH] vfs: update atimes over one day in the past or future
> >> 
> >> Relatime should update the inode atime if it is more than one day
> >> in the future.  The original problem seen was a tarball that had
> >> a bad atime in the distant future, but could also happen if someone
> >> fat-fingers a "touch".  The future atime will never be fixed.
> >> 
> >> Without relatime enabled, a future atime is updated to the current
> >> kernel time on access.  Relatime is meant to reduce the frequency
> >> of atime updates, not decide if whether the system clock or the
> >> inode timestamp is correct or not.
> >> 
> >> Signed-off-by: Yang Sheng <sickamd@gmail.com>
> >> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> >> Acked-by: David Chinner <david@fromorbit.com>
> > 
> > No I didn't. Please don't add tags that someone has not added
> > directly in a reply to the original patch.
> 
> That's my fault. I thought you'd OK'd the patch with the revised commit comment. 

Easy enough to misunderstand. :/

I simply avoid the issue by only adding tags that have been directly
sent by people...

> >> CC: stable@vger.kernel.org
> >> ---
> >> fs/inode.c | 7 ++++---
> >> 1 ??????????????????????????? 4 ???(+)????????? 3 ???(-)
> > 
> > There's something wrong with the character encoding you are using...
> 
> Chinese locale, but probably doesn't matter since text below "---" isn't in the commit anyway?

Yup, but it doesn't inspire confidence that the patch is going to be
clean when multiple encodings appear in the one message...

> > Also, you've added an extra line of whitespace damage that doesn't
> > need to be there.....
> > 
> > FWIW, could you write a test for xfstests for this behaviour
> > so we can confirm that we don't break it in future?
> 
> Sure, I'll take a crack at that. 

Great. Thanks for the followup, Andreas.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
