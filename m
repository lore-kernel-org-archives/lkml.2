Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0GARXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:23:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab0GARXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:23:33 -0400
Date: Fri, 2 Jul 2010 03:23:17 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100701172317.GB1830@laptop>
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
 <20100630124049.GH21358@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630124049.GH21358@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 10:40:49PM +1000, Nick Piggin wrote:
> But actually it's not all for scalability. I have some follow on patches
> (that require RCU inodes, among other things) that actually improve
> single threaded performance significnatly. git diff workload IIRC was
> several % improved from speeding up stat(2).

I rewrote the store-free path walk patch that goes on top of this
patchset (it's now much cleaner and more optimised, I'll post a patch
soonish). It is quicker than I remembered.

A single thread running stat(2) in a loop on a file "./file" has the
following cost (on an 2s8c Barcelona):

2.6.35-rc3	595 ns/op
patched		336 ns/op

stat(2) takes 56% the time with patches. It's something like 13 fewer
atomic operations per syscall.

What's that good for? A single threaded, cached `git diff` on the linux
kernel tree takes just 81% of the time after the vfs patches (0.27s vs
0.33s).

