Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0KWPFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:05:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:58859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0KWPFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:05:04 -0500
Subject: Re: [tip:sched/core] cpu: Remove incorrect BUG_ON
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101123143910.GA31502@redhat.com>
References: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org>
	 <20101123143910.GA31502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 16:05:04 +0100
Message-ID: <1290524704.2072.412.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 15:39 +0100, Oleg Nesterov wrote:
> On 11/23, tip-bot for Peter Zijlstra wrote:
> >
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -249,8 +249,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> >  	 * The migration_call() CPU_DYING callback will have removed all
> >  	 * runnable tasks from the cpu, there's only the idle task left now
> >  	 * that the migration thread is done doing the stop_machine thing.
> > +	 *
> > +	 * Wait for the stop thread to go away.
> >  	 */
> > -	BUG_ON(!idle_cpu(cpu));
> > +	while (!idle_cpu(cpu))
> > +		cpu_relax();
> 
> Yes... but I still can't understand why should we wait at all.
> 
> Peter, I am just curious, help ;)

Ah,. uhm,. you mean, not do anything at all?

Dunno, really, let me try and read the code there.


