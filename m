Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0HCOLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:11:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55990 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab0HCOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:11:37 -0400
Date: Tue, 3 Aug 2010 07:11:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100803141113.GD2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:56:10PM -0700, Arve Hjønnevåg wrote:
> On Sun, Aug 1, 2010 at 6:10 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sun, Aug 01, 2010 at 03:47:08PM -0700, Arjan van de Ven wrote:
> ...
> >> Another one: freezing whole cgroups..... we have that today. it
> >> actually works quite well.... of course the hard part is the decision
> >> what to put in which cgroup, and at what frequency and duration you let
> >> cgroups run.
> >
> > Indeed, the Android guys seemed to be quite excited by cgroup freezing
> > until they thought about the application-classification problem.
> > Seems like it should be easy for some types of applications, but I do
> > admit that apps can have non-trivial and non-obvious dependencies.
> 
> The dependencies is what made this solution uninteresting to us. For
> instance, we currently use cgroup scheduling to reduce the impact of
> some background tasks, but we occasionally saw a watchdog restart of
> the system process were critical services were waiting on a kernel
> mutex owned by a background task for more than 20 seconds. If we froze
> a cgroup instead, we would not hit this particular problem since tasks
> cannot be frozen while executing kernel code the same way they can be
> preempted, but nothing prevents a task from being frozen while holding
> a user-space resource.

Excellent point -- I had completely missed this failure mode!!!

							Thanx, Paul
