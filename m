Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1H3Nga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 09:36:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:37595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1H3Ng3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 09:36:29 -0400
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in
 list_add_leaf_cfs_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: "\"Jan H." =?ISO-8859-1?Q?Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Aug 2011 15:35:54 +0200
In-Reply-To: <4E557DCC.5050308@cs.tu-berlin.de>
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1314125615.8002.90.camel@twins> <4E556CB2.3060502@cs.tu-berlin.de>
	 <CAPM31RK1xvA6pige9zrLce0JeBDpaPa_WfN-bsR9_ZJDRtn87g@mail.gmail.com>
	 <4E557DCC.5050308@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314711354.5812.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 00:40 +0200, "Jan H. Schönherr" wrote:
> Am 24.08.2011 23:32, schrieb Paul Turner:
> >>> Now I don't really like the above because its hard to make the code go
> >>> away in the !FAIR_GROUP case, but maybe we can come up with something
> >>> for that.
> >>
> >> Hmmm... you might want to reconsider my original approach to solve this:
> >> http://lkml.org/lkml/2011/7/18/86
> >>
> >> That might have been the cleanest one in this respect.
> >>
> >> Paul Turner did not like the introduced in-order removal, but the
> >> out-of-order removal is causing most problems.
> >>
> > 
> > Sorry for the delayed reply -- I owe you some feedback on the updated
> > versions but have been buried with other work.
> 
> No problem.
> 
> > What I didn't like about the original approach was specifically the
> > positional dependence on enqueue/dequeue. 
> 
> Maybe I misunderstood you, then.
> 
> If we can guarantee in-order removal of leaf_cfs_rqs, then there is
> no positional dependency. Any SE can be enqueued and dequeued anytime.
> 
> OTOH, the RCU splice variant has a positional dependence: calling
> enqueue_entity() outside of enqueue_task_fair() can go wrong easily as it
> depends on being called bottom-up and requires its caller to maintain state.
> 
> This is also partly true for the leaf_insertion_point variant: if a caller
> maintains state, then the pair enqueue_entity/enqueue_leaf_cfs_rq() also
> depends on being called bottom up.
> 
> 
> > If we can't do the splicing
> > properly then I think we want something like:
> > https://lkml.org/lkml/2011/7/18/348 to avoid shooting ourselves in the
> > future later.
> > 
> > See: https://lkml.org/lkml/2011/7/19/178 for why this should be cheap.
> 
> As far as I can tell, all three variants proposed so far work.
> 
> It is probably a matter of taste in the end. I'll happily help with
> whatever version tastes best. :)


pjt, you said you were rewriting the cgroup stuff yet-again, any
preference for which solution would least get in your way?
