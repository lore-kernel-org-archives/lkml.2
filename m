Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2FLWe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:34:28 -0400
Received: from fifo99.com ([67.223.236.141]:35435 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2FLWe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:34:27 -0400
Date: Tue, 12 Jun 2012 15:34:22 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: fweisbec@gmail.com, msb@chromium.org, sshaiju@mvista.com, mingo@elte.hu,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: hung_task checking and sys_sync
Message-ID: <20120612223422.GB13492@fifo99.com>
References: <20120612220924.GA13376@fifo99.com> <20120612222912.GB16381@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612222912.GB16381@google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 03:29:12PM -0700, Mandeep Singh Baines wrote:
> 
> But the time is not unbounded. You could mask the hung_task_detector for
> this case but then you lose the ability to catch bugs in this code path.
> 
> The timeout is configurable via /proc/sys/kernel/hung_task_timeout_secs.
> Can you bump up the value at boot via sysctl.conf?

Maybe, but I'm wondering if these types should just be stopped because Andrew
had complained about them already.
 
> > Has there been any commit that disable these messages bdi_sched_wait?
> > 
> 
> No. There is no mechanism to disable hung_task for a specific code path.
> We do skip processes if PF_PROZEN or PF_FROZEN_SKIP is set but that is
> really a different situation where the wait is unbounded.

There is presidence for this type of change, 

Author: Mark Lord <kernel@teksavvy.com>
Date:   Fri Sep 24 09:51:13 2010 -0400

    block: Prevent hang_check firing during long I/O
    
    During long I/O operations, the hang_check timer may fire,
    trigger stack dumps that unnecessarily alarm the user.
    
    Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to complete
    
    So, if hang_check is armed, we should wake up periodically
    to prevent it from triggering.  This patch uses a wake-up interval
    equal to half the hang_check timer period, which keeps overhead low enough.
    
    Signed-off-by: Mark Lord <mlord@pobox.com>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

