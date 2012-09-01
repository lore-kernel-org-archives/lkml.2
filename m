Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2IACC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 22:02:58 -0400
Received: from infernal.debian.net ([176.28.9.132]:45409 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2IACC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 22:02:57 -0400
Date: Sat, 1 Sep 2012 04:02:52 +0200
From: Andreas Bombe <aeb@debian.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION] Xorg doesn't like 4e8b14526 "time: Improve sanity
 checking of timekeeping inputs"
Message-ID: <20120901020252.GA6402@amos.fritz.box>
References: <20120831040500.GA6090@amos.fritz.box>
 <5040F7CE.6030505@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040F7CE.6030505@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 10:43:42AM -0700, John Stultz wrote:
> On 08/30/2012 09:05 PM, Andreas Bombe wrote:
> >With that somewhat easy test I bisected it down to 4e8b14526 "time:
> >Improve sanity checking of timekeeping inputs". The latest Linus git
> >(155e36d40) with a revert of the bisected commit does not show the
> >problem.
> 
> Thanks so much for bisecting this down!
> I'm guessing X is passing crazy large timespecs into select (via
> WaitForSomething()) values that are catching on the ktime_t overflow
> check in timespec_valid(). Previously these would be clamped to
> KTIME_MAX (which basically is infinity) in the timer subsystem
> before.
> 
> So the issue is the patch in question is too strict in its
> validation. We want to be strict on things like timekeeping inputs,
> but for timers wait to infinity is still valid.
> 
> The attached (sorry not inline, on the road) patch should fix this,
> but could you verify it? (I'm running my testing concurrently)

I'm running it now and it's looking good. I did the video test again and
confirmed with strace that X was doing the giant timeout in select
again, but this time without any errors.

-- 
Andreas Bombe
