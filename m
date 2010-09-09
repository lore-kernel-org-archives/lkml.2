Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0IISvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:51:02 -0400
Received: from ist.d-labs.de ([213.239.218.44]:58538 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab0IISu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:50:58 -0400
Date: Thu, 9 Sep 2010 20:50:56 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-ID: <20100909205056.1ac7989a@schatten.dmk.lab>
In-Reply-To: <4C88B55E.90203@kernel.org>
References: <4C87AE52.70401@kernel.org>
	<4C87B101.2080608@kernel.org>
	<20100909100229.250900f0@schatten.dmk.lab>
	<4C88B55E.90203@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Sep 2010 12:22:22 +0200
Tejun Heo <tj@kernel.org> wrote:

> The backend mechanism is called Global CPU Workqueue (gcwq).  There is

I tried to avoid that name. It somehow is confusing to me . Global/Local
in context of CPU is somehow associated with CPU locality in my mind.
Also the name doesn't fit for the unbound gcwq. 
I know what you mean by it, but I don't think it's a self explanatory
name. That was why I just said "they are called gcwq". But I'm ok with
it either way. After all, that _is_ how they are called. :) 


> > 
> > I think it is worth mentioning all functions that are considered to be
> > part of the API here. 
> 
> Yeah, that would be nice but a slightly larger task that I would like
> to postpone at this point.  :-)

Ah well, I may just give it a go then... 

> 
> > "Unless work items are expected to consume a huge amount of CPU
> > cycles, using a bound wq is usually beneficial due to the increased
> > level of locality in wq operations and work item exection. "
> 
> So updated.
> 
> > Btw, it is not clear to me, what you mean with "wq operations". 
> 
> Queueing, dispatching and other book keeping operations.

Yes. That makes sense. 

> 
> > Do the enqueuing API functions automatically determine the cpu they are
> > executed on and queue the workitem to the corresponding gcwq? Or do you
> > need to explicitly queue to a specific CPU?
> > 
> > Either you mean the operations that lead to the enqueueing of the
> > work-item, or you mean the operations done by the thread-pool?
> > 
> > ... after thinking a bit, the wq implementation should obviously do the
> > automatic enqueuing on the nearest gcwq thingy... But that should
> > probably be mentioned in the API description. 
> > Although I have to admit I only skimmed over the flag description
> > above it seems you only mention the UNBOUND case and not the default
> > one?
> 
> Yeah, queue_work() queues works on the gcwq of the local CPU.  It can
> be overridden by queue_work_on().  The unbound is special case where
> the workqueue always sends works to the unbound gcwq which is served
> by unbound workers.  Did the update in the design section explain
> enough or do you think there needs to be more explanation?

I'm looking forward to reading the new version en
bloc, but if I can trust my gut feeling, I'm ok with it now. :)

Let's see if someone else with more kernel-experience has something to
add, but here you've got my

Reviewed-By: Florian Mickler <florian@mickler.org>

in any case.

Cheers,
Flo
