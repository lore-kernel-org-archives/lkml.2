Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0HDQcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:32:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56447 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0HDQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:32:23 -0400
Date: Wed, 4 Aug 2010 09:32:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804163216.GB24163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100803183447.0275c134@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 06:34:47PM -0700, Arjan van de Ven wrote:
> On Mon, 2 Aug 2010 21:56:10 -0700
> Arve Hjønnevåg <arve@android.com> wrote:
> 
> > > non-obvious dependencies.
> > >
> > 
> > The dependencies is what made this solution uninteresting to us. For
> > instance, we currently use cgroup scheduling to reduce the impact of
> > some background tasks, but we occasionally saw a watchdog restart of
> > the system process were critical services were waiting on a kernel
> > mutex owned by a background task for more than 20 seconds. If we froze
> > a cgroup instead, we would not hit this particular problem since tasks
> > cannot be frozen while executing kernel code the same way they can be
> > preempted, but nothing prevents a task from being frozen while holding
> > a user-space resource.
> 
> one of the solutions we're looking at to solve this is to unfreeze the
> cgroup on a regular basis (say, every 15 to 30 seconds) briefly to avoid
> this kind of deadlock...

Cute!!!  ;-)

If this doesn't work for the Android folks for whatever reason, another
approach would be to do the freeze in user code, which could track
whether any user-level resources (pthread mutexes, SysV semas, whatever)
where held, and do the freeze on a thread-by-thread basis within each
"victim" application as the threads reach safe points.

I must of course defer to the Android folks as to whether or not this
would actually work for Android.  But if your approach works for them,
why worry?

							Thanx, Paul
