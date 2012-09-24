Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2IXSTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:19:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52660 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab2IXSTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:19:32 -0400
Message-ID: <1348510768.618.16.camel@maxim-laptop>
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Sep 2012 20:19:28 +0200
In-Reply-To: <20120924180516.GF7694@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
	 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
	 <20120919145228.80f72f59.akpm@linux-foundation.org>
	 <1348113942.16096.18.camel@maxim-laptop>
	 <20120920175340.GE28934@google.com> <1348498747.618.4.camel@maxim-laptop>
	 <1348499363.618.6.camel@maxim-laptop> <20120924180516.GF7694@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 11:05 -0700, Tejun Heo wrote: 
> Hello,
> 
> On Mon, Sep 24, 2012 at 05:09:23PM +0200, Maxim Levitsky wrote:
> > > Now that my exams done....
> > > Can you spare me from using a workqueue?
> 
> I'd much prefer if you convert to workqueue.
> 
> > > The point is that using current model I wake the worker thread as much
> > > as I want to, and I know that it will be woken once an will do all the
> > > work till request queue is empty.
> 
> You can do exactly the same thing by scheduling the same work item
> multiple times.  "Waking up" just becomes "scheduling the work item".
I don't believe that will work this way.
I will dig through the source, and see how to do that.



> > > With workqueues, it doesn't work this way. I have to pass the request as
> > > a work item or something like that.
> > > Any pointers?
> 
> No, there's no reason to change the structure of the code in any way.
> Just use a work item as you would use a kthread.
Except that if I schedule a same work item few times, these work items
will be 'processed' in parallel, although there is just one work to do,
work of pulling the requests from block queue until it has them, and
dispatching them through my code.
Or I can get a guarantee that work items wont be processed in parallel?
Stiil, even with that only first work item will do the actual work,
others will wake the workqueue for nothing, but I am ok with that.



> 
> > Also probably due to that reason MMC doesn't use a workqueue ether, but
> > a raw kthread, in pretty much same way I do.
> 
> Mostly because I haven't gotten around to convert it yet.  The
> problems with direct kthread usage are that they're much more
> difficult to get completely correct with freeze and exit conditions -
Agreed, I had my own share of frustration with this. I got it right in
the end though.

> the last time I checked it was easier to spot broken ones than correct
> ones - and they create dedicated threads which usually are
> underutilized.
True too, although, a sleeping thread doesn't cost much. 
> 
> Thanks.
> 

-- 
Best regards,
        Maxim Levitsky


