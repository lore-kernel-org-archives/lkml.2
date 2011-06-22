Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab1FVOix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:38:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59208 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:38:52 -0400
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
In-Reply-To: <alpine.LFD.2.02.1106221628560.11814@ionos>
References: <20110621233444.094372367@chello.nl>
	 <20110621233648.806475812@chello.nl> <4E019353.6030902@fusionio.com>
	 <alpine.LFD.2.02.1106221015320.11814@ionos> <4E01F5D6.1020107@fusionio.com>
	 <alpine.LFD.2.02.1106221628560.11814@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 16:38:01 +0200
Message-ID: <1308753481.1022.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 16:30 +0200, Thomas Gleixner wrote:
> > It is supposedly a real problem, not just an inkling. It's not about
> > recursing indefinitely, the plug is fairly bounded. But the IO dispatch
> > path can be pretty deep, and if you hit that deep inside the reclaim or
> > file system write path, then you get dangerously close. Dave Chinner
> > posted some numbers in the 2.6.39-rc1 time frame showing how close we
> > got.
> 
> Fair enough.

> Ok. So we move it out and keep the from_scheduler flag so that code
> does not go down the IO path from there. 

Won't punting the plug to a worker thread wreck all kinds of io
accounting due to the wrong task doing the actual io submission?
