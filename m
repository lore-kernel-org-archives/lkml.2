Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1ADQTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:19:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:33656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1ADQTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:19:18 -0500
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
In-Reply-To: <1294156524.6169.147.camel@Palantir>
References: <1294156524.6169.147.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 17:19:04 +0100
Message-ID: <1294157944.2016.166.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 16:55 +0100, Dario Faggioli wrote:

> They're not inside an union yet, because I'm not sure on how to treat
> the task group case. In fact, tasks can only have _just_one_ scheduling
> policy at a time, and thus, for example, they need the run_list _or_ the
> rb_node for queueing (if the task is RT or fair, respectively), which is
> perfect with respect to using an union.
> OTOH, groups are always considered both fair _and_ RT entities, for
> example they're always queued in _both_ an RT run_list and a fair
> rb-tree. So I can't put them in an union, because I need both at the
> same time!

Just like its now, keep a sched_entity per class.

struct task_group {

#ifdef CONFIG_FAIR_GROUP_SCHED
	struct sched_entity **cfs_se;
	...
#endif

#ifdef CONFIG_RT_GROUP_SCHED
	struct sched_entity **rt_se;
	...
#endif

}

> And as usual, comments of any kind are very very welcome! :-)

Yay!

I see once clash with my current ttwu patch set though, see:

  http://lkml.org/lkml/2011/1/4/228

But that should be easy to resolve.
