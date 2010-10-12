Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0JLQzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:55:08 -0400
Received: from www.tglx.de ([62.245.132.106]:44869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0JLQzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:55:07 -0400
Date: Tue, 12 Oct 2010 18:54:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Salman Qazi <sqazi@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
In-Reply-To: <AANLkTikgvZuT5+sgPyD-1j1gG+-pC0+4hpXQj7Z_ZuYE@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010121848061.2909@localhost6.localdomain6>
References: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com> <alpine.LFD.2.00.1010121046060.2909@localhost6.localdomain6> <AANLkTikgvZuT5+sgPyD-1j1gG+-pC0+4hpXQj7Z_ZuYE@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-204775361-1286902461=:2909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-204775361-1286902461=:2909
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 Oct 2010, Salman Qazi wrote:
> On Tue, Oct 12, 2010 at 1:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 11 Oct 2010, Salman Qazi wrote:
> >> /* There are other issues, like deadlocks between multiple hrtimer_start observed
> >>  * calls, at least in 2.6.34 that this lock works around.  Will look into
> >>  * those later.
> >
> > Well, we don't have to work around callsites not serializing themself
> > in the core code, right ?
> 
> I assumed that the semantics were that hrtimer_starts are serialized
> with respect to each other and with respect to cancels.   You seem to
> disagree.

Yes, I disagree. The code makes sure that cancel/start does not
conflict with a running callback, but it's not responsible for random
code fiddling with the same timer, really.

The outcome of random start/cancel operations on two cpus of the same
timer is just unpredictible, so where is the point of caring about
that in the core code ?

> In any case, I have to rerun that test without this lock with the
> patch present.  It's possible that it was a symptom of the same bug
> that we just didn't observe in production.

Which bug did you observe in production and what's the code which is
triggering this?

Thanks,

	tglx
---1463795968-204775361-1286902461=:2909--
