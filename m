Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0D0NTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:19:13 -0400
Received: from www.tglx.de ([62.245.132.106]:34763 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578Ab0D0NTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:19:06 -0400
Date: Tue, 27 Apr 2010 15:18:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Primiano Tucci <p.tucci@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       rostedt <rostedt@goodmis.org>
Subject: Re: Considerations on sched APIs under RT patch
In-Reply-To: <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004271517440.2951@localhost.localdomain>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>  <1271755208.1676.422.camel@laptop> <k2nc5b2c05b1004201456j846b15a0oaa261d16740b5e33@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-862821315-1272374334=:2951"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-862821315-1272374334=:2951
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 20 Apr 2010, Primiano Tucci wrote:

> Hi Peter,
> thank you for your reply.
> 
> On Tue, Apr 20, 2010 at 11:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-04-19 at 22:48 +0200, Primiano Tucci wrote:
> >
> >> Yesterday days I found a strange behavior of the scheduler API's using
> >> the RT patch, in particular the pthread_setaffinity_np (that stands on
> >> sched_setaffinity).
> >
> >> I think the main problem is that sched_setaffinity makes use of a
> >> rwlock, but rwlocks are pre-emptible with the RT patch.
> >
> > It does? where?
> >
> > sys_sched_setaffinity()
> >  sched_setaffinity()
> >    set_cpus_allowed_ptr()
> 
> 
> I see
> 
> long sched_setaffinity(pid_t pid, const struct cpumask *in_mask) {
> 	cpumask_var_t cpus_allowed, new_mask;
> 	struct task_struct *p;
> 	int retval;
> 
> 	get_online_cpus();
> -->	read_lock(&tasklist_lock);

You must be looking at some older version of -rt. The current
2.6.33-rt series does not take tasklist_lock in sched_setaffinity().

Thanks,

	tglx
--8323328-862821315-1272374334=:2951--
