Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1KQNKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:10:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1KQNKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:10:48 -0500
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Nov 2011 14:10:12 +0100
In-Reply-To: <20111117130032.GC16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
	 <1321534159.27735.33.camel@twins> <20111117130032.GC16853@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321535413.27735.35.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 15:00 +0200, Gleb Natapov wrote:

> > That said, I'd much rather throttle this particular jump label than
> > remove it altogether, some people really don't like all this scheduler
> > hot path crap.
> What about moving perf_event_task_sched() to sched_(in|out)_preempt_notifiers?
> preempt notifiers checking is already on the scheduler hot path, so no
> additional overhead for perf case.

Same problem really, some people complain about the overhead of preempt
notifiers, also not all kernels have those in. 

Futhermore I loathe notifier lists because they obscure wtf is done.
