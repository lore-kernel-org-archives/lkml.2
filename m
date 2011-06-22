Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1FVOan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:30:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:37622 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab1FVOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:30:41 -0400
Date: Wed, 22 Jun 2011 16:30:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jens Axboe <jaxboe@fusionio.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
In-Reply-To: <4E01F5D6.1020107@fusionio.com>
Message-ID: <alpine.LFD.2.02.1106221628560.11814@ionos>
References: <20110621233444.094372367@chello.nl> <20110621233648.806475812@chello.nl> <4E019353.6030902@fusionio.com> <alpine.LFD.2.02.1106221015320.11814@ionos> <4E01F5D6.1020107@fusionio.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, Jens Axboe wrote:
> On 2011-06-22 15:53, Thomas Gleixner wrote:
> > On Wed, 22 Jun 2011, Jens Axboe wrote:
> > Is that a real problem or just a "we have no clue what might happen"
> > countermeasure? The plug list should not be magically refilled once
> > it's split off so this should not recurse endlessly, right? If it does
> > then we better fix it at the root cause of the problem and not by
> > adding some last resort band aid into the scheduler code.
> 
> It is supposedly a real problem, not just an inkling. It's not about
> recursing indefinitely, the plug is fairly bounded. But the IO dispatch
> path can be pretty deep, and if you hit that deep inside the reclaim or
> file system write path, then you get dangerously close. Dave Chinner
> posted some numbers in the 2.6.39-rc1 time frame showing how close we
> got.

Fair enough.
 
> We are talking past each other again. Flushing on going to sleep is
> needed. Placement of that call was pretty much left in the hands of the
> scheduler people. I personally don't care where it's put, as long as it
> does what is needed.

Ok. So we move it out and keep the from_scheduler flag so that code
does not go down the IO path from there.
 
Thanks,

	tglx
