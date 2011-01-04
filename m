Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADT0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:26:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:50146 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab1ADT0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:26:42 -0500
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dario Faggioli <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co, lucas.de.marchi@gmail.com
In-Reply-To: <1294164700.6169.197.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
	 <1294157944.2016.166.camel@laptop>  <1294164700.6169.197.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 20:26:37 +0100
Message-ID: <1294169197.2016.188.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 19:11 +0100, Dario Faggioli wrote:
> > struct task_group {
> > 
> > #ifdef CONFIG_FAIR_GROUP_SCHED
> >       struct sched_entity **cfs_se;
> >       ...
> > #endif
> > 
> > #ifdef CONFIG_RT_GROUP_SCHED
> >       struct sched_entity **rt_se;
> >       ...
> > #endif
> > 
> > }
> > 
> Well, sure this can be done. But what about the common fields? I guess
> you're suggesting to use something like `struct sched_entity_common' and
> putting them there, aren't you?
> 
> If yes, I'm fine with that, although it'll add one more level of
> indirection for those fields (e.g., p->se.comm.on_rq). Are we cool with
> this? 

I'm pretty sure we're mis-understanding each other here, I meant to keep
two complete sched_entity structures (both containing the common/fair/rt
parts). That way, one can use the fair and the other the rt part.
