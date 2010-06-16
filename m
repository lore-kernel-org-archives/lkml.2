Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0FPPLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:11:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15290 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0FPPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:11:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44617190"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18E4B7.5040702@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org> <1276694825.9309.12.camel@m0nster>
	 <4C18D1FD.9060804@kernel.org> <1276695665.9309.17.camel@m0nster>
	 <4C18D574.1040903@kernel.org> <1276697146.9309.27.camel@m0nster>
	 <4C18DC69.10704@kernel.org> <1276698880.9309.44.camel@m0nster>
	 <4C18E4B7.5040702@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 08:11:14 -0700
Message-ID: <1276701074.9309.60.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 16:50 +0200, Tejun Heo wrote:
> Hi,
> 
> On 06/16/2010 04:34 PM, Daniel Walker wrote:
> >> Come on.  The user can't even know what's going on each workqueue
> >> thread.  Something you can do doesn't make it a good idea.  In this
> >> case, it's a very bad idea.
> > 
> > You just don't understand the use case. Let say I have a high priority
> > thread in userspace , and I discover through analysis that my thread is
> > being forced to wait on a workqueue thread (priority inversion) , so
> > then I just increase the workqueue thread priority to overcome the
> > inversion. That's totally valid, and you don't even need to know exactly
> > what the thread is doing..
> > 
> > Now lets say the same thing happens under your changes.. Well, then I'm
> > screwed cause your changes turn the workqueues into a opaque thread
> > cloud which can't be prioritized.
> 
> If you find that some work item is causing priority inversion, you
> need to fix the problem instead of working around in adhoc way which
> won't be useful to anyone else, so, no, it doesn't sound like a useful
> use case.

How do I fix the problem then? Without doing what I've already
suggested.

> >>> In fact there has been a lot of work in the RT kernel related to
> >>> workqueue prioritization ..
> >>
> >> That frankly I don't have much idea about.
> > 
> > Exactly, but I do know about it which is why we're talking. So your
> > saying that use cases that you don't know about don't really matter
> > right?
> 
> Peter brought up the work priority issue previously and Linus was
> pretty clear on the issue.  They're in the discussiosn for the first
> or second take.

Send us a link to this discussion.

> > Your completely wrong .. Look at the example I gave above .. Bottom line
> > is that your removing currently useful functionality, which is bad.. You
> > can say it's not useful, but again you also say you don't "have much
> > idea" regarding the cases where this is actually important.
> 
> I said that I didn't have much idea about RT work priority thing, not
> setting priority on wq workers for adhoc workaround for whatever.
> IIRC, the RT work priority thing Peter was talking about was a
> different thing.  Sure, more complex workqueue implementation would
> complicate implementing work priorities, but if necessary maybe we can
> grow different classes of worker pools.

Ok .. So what would these different classes look like then ? Is that
something I could prioritize from userspace perhaps ?

> > Could you please just entertain the idea that maybe someone somewhere
> > might want to give priorities to the work items inside your system.
> 
> If that's necessary, do it properly.  Give *work* priorities or at
> least give explicit priorities to workqueues.  That's a completely
> different thing from insisting fixed workqueue to kthread mapping so
> that three people on the whole planet can set priority on those
> kthreads not even knowing what the hell they do.

You have no idea how many people are doing this, or in what
circumstances .. Please don't make mass speculation over things you
clearly are not aware of.

I'm not insisting any fixed mapping, you need to open you mind to
_possibilities_ .. How can the work items be given priorities _inside
your system_! Can you give an interface in which people can set a
priority to a give type of work item, then maybe you system honors those
priorities in _some way_ ..

In fact, I'm only asking that you consider it, ponder it..

> > I mean consider the RT workqueue that you removed, why in the world
> > would we even have that if giving workqueues special priorities was
> > a bad thing (or not useful).
> 
> Because stop_machine wnated to use wq as a frontend for threads which
> I converted to cpu_stop and which actually proves my point not yours,
> sorry.

I'm not sure your proving much here, other than you thought it was
better to use another method.

Daniel

