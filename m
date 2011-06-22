Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab1FVPJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 11:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975Ab1FVPJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 11:09:13 -0400
Date: Wed, 22 Jun 2011 11:08:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH 1/3] sched, block: Move unplug
Message-ID: <20110622150825.GE17010@redhat.com>
References: <20110621233444.094372367@chello.nl>
 <20110621233648.806475812@chello.nl>
 <4E019353.6030902@fusionio.com>
 <alpine.LFD.2.02.1106221015320.11814@ionos>
 <4E01F5D6.1020107@fusionio.com>
 <alpine.LFD.2.02.1106221628560.11814@ionos>
 <1308753481.1022.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308753481.1022.27.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 04:38:01PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-22 at 16:30 +0200, Thomas Gleixner wrote:
> > > It is supposedly a real problem, not just an inkling. It's not about
> > > recursing indefinitely, the plug is fairly bounded. But the IO dispatch
> > > path can be pretty deep, and if you hit that deep inside the reclaim or
> > > file system write path, then you get dangerously close. Dave Chinner
> > > posted some numbers in the 2.6.39-rc1 time frame showing how close we
> > > got.
> > 
> > Fair enough.
> 
> > Ok. So we move it out and keep the from_scheduler flag so that code
> > does not go down the IO path from there. 
> 
> Won't punting the plug to a worker thread wreck all kinds of io
> accounting due to the wrong task doing the actual io submission?

I think all the accounting will the done in IO submission path and
while IO is added to plug. This is just plug flush so should not
have effect on accounting.

Thanks
Vivek
