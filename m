Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0GJPLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:11:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0GJPLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:11:42 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278748227.4390.26.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685951.1900.215.camel@laptop>  <1278748227.4390.26.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 10 Jul 2010 17:11:28 +0200
Message-ID: <1278774688.1998.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 09:50 +0200, Raistlin wrote:

> Hey, fine, where's the problem? :-P

We're talking about it.. the exact semantics and the reasons
therefore ;-)

> > What are the exact semantics of this extra proposed syscall?
> > 
> Right now, it is:
> task_wait_interval(t) --> "wake me up at the first instant after t when 
> 			   you can give me my full runtime"
> 
> > What exactly are the benefits over not having it, and simply rely on the
> > task to not wake up more often, but if it does have it run into the lack
> > of budget and sort it that way?
> >
> What you're saying obviously will always work, and it is actually a
> quite common usage pattern (we use it like that a lot! :-)).
> 
> The new syscall might help when it is important for a task to
> synchronize with the budget provisioning mechanism. It might be
> uncommon, but there could be situations --more in hard than in soft
> scenarios-- where you want to be sure that you're next job (and all the
> subsequent ones, if you behave well) will get its full runtime, even if
> this means waiting a little bit.
> 
> what I was wondering was if this semantic should be modified by the
> introduction of the "period", but I also agree with Luca that we must do
> our best to avoid confusion!

Right, so I would actually expect RT job release to be triggered by
external events (say interrupts) more than on their own. And when its an
external event I don't really see the use of this new syscall.

I guess I'm asking for what reason RT tasks would be ever be
self-releasing, it seems, odd..
