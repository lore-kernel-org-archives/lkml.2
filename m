Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0GTO7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:59:49 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56987 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab0GTO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gWaWcwzqlMgI2UTx0GDyS26fAXxEyXvh0jOtsPtgTq1iQyqsbQUArVsdQUEr2/hTJa
         Jam+Dv7R8P4S5UL7JhqCYpp8m10vyUM6r8DGZ6un/kzctVlIrN7G0Ph4B6jki73nUSLB
         igwv480rPfx70NKfkkwwj486CW8iaSbdpMWTs=
Date: Tue, 20 Jul 2010 16:59:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Pierre Tardy <tardyp@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf migration
Message-ID: <20100720145938.GA5943@nowhere>
References: <20100707151318.GA5984@nowhere> <20100708071942.GA26454@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708071942.GA26454@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 09:19:42AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> > 
> > To begin with, the name is a bit pompous. It's not a strong cpu task 
> > migration observer as it's only based on the number of tasks living in a cpu 
> > runqueue. This is the only basis for the cpu load: it doesn't handle the 
> > nice level, scheduler classes, of each tasks (except idle ones that don't 
> > count on the load).
> > 
> > At least not yet.
> > 
> > But still I think it's a cool toy, I've been playing with it for the last 
> > weeks and it can give you a nice overview of what happens wrt migration 
> > decisions for each migration opportunities: wake up, fork and exec, sleep 
> > (sleep doesn't involve migration decision, but it's still an rq detach), and 
> > load balancing. In fact it's more about "runqueue events".
> 
> Cool, looks really nice!
> 
> > == How to use ==
> > 
> > 
> > I suggest you to use latest tip:/perf/core
> > 
> > Run the following command (followed by a command if you want):
> > 
> > $ sudo ./perf record -m 16384 -a -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task
> 
> Does 'perf sched record' include these events?



Yeah. In fact it would include too much by adding traces you don't need, so there
are more risks to lose traces while using perf sched record.



 
> > Now ensure you have no lost events:
> > 
> > 
> > $ sudo ./perf trace -d
> > Misordered timestamps: 0
> > Lost events: 0 <----
> 
> We need some warning for this in the GUI i guess?



Yeah. In fact we need to add that from the tracing/scripting layer
and always check/report lost events to the user.



> > If so you need to increase the buffer size (-m nr_pages option in perf record).
> > 
> > Then put the script in the tools/perf directory and run it:
> > 
> > $ ./perf trace -s migration.py
> > 
> > You'll need wxpython.
> 
> Looks like this could be turned into 'perf sched view' or 'perf sched 
> migration'?
> 
> How tasks schedule/migrate is basically how scheduler developers look at 
> sched-trace data, so it would be nice if your GUI became the gui for perf 
> sched.
> 
> 	Ingo



Agreed. For now it's very tied to the cpu load idea, so the code needs to
be generalized to easily plug other sched drawing plugins. But yeah, that would
be indeed a good direction.

