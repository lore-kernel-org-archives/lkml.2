Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0GKGP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:15:59 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:44602 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0GKGP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:15:58 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1278748227.4390.26.camel@Palantir>
Date: Sun, 11 Jul 2010 08:15:23 +0200
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <2E44C782-B72E-41FE-A6C8-68800218FE40@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685951.1900.215.camel@laptop> <1278748227.4390.26.camel@Palantir>
To: Raistlin <raistlin@linux.it>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10, 2010, at 9:50 AM, Raistlin wrote:

>> 
>> What are the exact semantics of this extra proposed syscall?
>> 
> Right now, it is:
> task_wait_interval(t) --> "wake me up at the first instant after t when 
> 			   you can give me my full runtime"
> 
>> What exactly are the benefits over not having it, and simply rely on the
>> task to not wake up more often, but if it does have it run into the lack
>> of budget and sort it that way?
>> 
> What you're saying obviously will always work, and it is actually a
> quite common usage pattern (we use it like that a lot! :-)).
> 
> The new syscall might help when it is important for a task to
> synchronize with the budget provisioning mechanism. It might be
> uncommon, but there could be situations --more in hard than in soft
> scenarios-- where you want to be sure that you're next job (and all the
> subsequent ones, if you behave well) will get its full runtime, even if
> this means waiting a little bit.

Isn't this basically sched_yield? Don't run me now, give lower-priority work a chance to complete, let me run again when my budget is replenished.

Otherwise, what are the semantics of sched_yield under EDF? Cycle through equal-deadline jobs? Given sporadic task activations, this is probably not very useful.

- Björn

