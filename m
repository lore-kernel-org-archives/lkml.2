Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2HPOEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:04:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab2HPOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:04:11 -0400
Date: Thu, 16 Aug 2012 10:03:56 -0400
From: Dave Jones <davej@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120816140356.GA1538@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20120724203613.GA9637@redhat.com>
 <20120727162038.GD12244@redhat.com>
 <CACVXFVO-_bP33syDr22TkX2Rsfhb6rNmUNBtsQBnnyqJxdXRyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVO-_bP33syDr22TkX2Rsfhb6rNmUNBtsQBnnyqJxdXRyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:54:31PM +0800, Ming Lei wrote:
 > On Sat, Jul 28, 2012 at 12:20 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Tue, Jul 24, 2012 at 04:36:13PM -0400, Dave Jones wrote:
 > >  > Linus tree as of 5fecc9d8f59e765c2a48379dd7c6f5cf88c7d75a
 > >  >
 > >  >      Dave
 > >  >
 > >  > ======================================================
 > >  > [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
 > >  > 3.5.0+ #122 Not tainted
 > >  > ------------------------------------------------------
 > >  > trinity-child2/5327 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 > >  > blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff8109762b>] posix_cpu_timer_del+0x2b/0xe0
 > >  >
 > >  > and this task is already holding:
 > >  > blocked:  (&(&new_timer->it_lock)->rlock){-.-...}, instance: ffff880143bce170, at: [<ffffffff81093d49>] __lock_timer+0x89/0x1f0
 > >  > which would create a new lock dependency:
 > >  >  (&(&new_timer->it_lock)->rlock){-.-...} -> (tasklist_lock){.+.+..}
 > >  >
 > >  > but this new dependency connects a HARDIRQ-irq-safe lock:
 > >  >  (&(&new_timer->it_lock)->rlock){-.-...}
 > >  > ... which became HARDIRQ-irq-safe at:
 > >
 > > Shall I start bisecting this ? I can trigger it very easily, but if you
 > > can give me a set of commits to narrow down, it'll speed up the bisection.
 > 
 > It should a real possible deadlock, could you test the below patch to
 > see if it can fix the warning?

I've not managed to hit it in a while. It seems very dependant upon
specific builds for some reason.  Very strange.

	Dave 
