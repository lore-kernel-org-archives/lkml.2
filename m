Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2AYLCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:02:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:57900 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2AYLCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:02:24 -0500
Date: Wed, 25 Jan 2012 12:02:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Karsten Wiese <fzuuzf@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from invalid
 context
In-Reply-To: <CAONaPpHJM1GKdRCdvw97AsBSRQk1oHUt6u2bGJRoin+e59Wbzg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1201251156310.2716@ionos>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com> <201201180053.52617.fzuuzf@googlemail.com> <1326848525.17534.66.camel@gandalf.stny.rr.com> <CAONaPpGHULxDZXBTprkCy9vKPH46gHOiQs6GM_ysfP2znDqqXg@mail.gmail.com>
 <1326991117.17534.132.camel@gandalf.stny.rr.com> <CAONaPpHJM1GKdRCdvw97AsBSRQk1oHUt6u2bGJRoin+e59Wbzg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1286624960-1327489340=:2716"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1286624960-1327489340=:2716
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 19 Jan 2012, John Kacur wrote:

> On Thu, Jan 19, 2012 at 5:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Thu, 2012-01-19 at 17:16 +0100, John Kacur wrote:
> > 
> >> I'm testing v3.0.14-rt32-rc1, and it greatly reduced the number of
> >> these, but I still got one during boot.
> >>
> >> [   11.938649] BUG: sleeping function called from invalid context at
> >> /home/jkacur/rt.linux.git/kernel/rtmutex.c:645
> >> [   11.938651] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
> >> [   11.938653] 1 lock held by irq/9-acpi/168:
> >> [   11.938653]  #0:  (acpi_gbl_gpe_lock){......}, at:
> >> [<ffffffff8123881d>] acpi_ev_gpe_detect+0x31/0x110
> >
> > Could you test 3.2-rt. If that has the issue then we know we have more
> > to fix. If not, we know I missed a patch.
> >
> 
> I tested with v3.2-rt10 and the issue is not there.

I'm surprised. I know already what the problem is and according to the
code it should be visible in 3.2 as well. I'm still twisting my head
around that acpi maze to fix that particular one.

> I also examined your patches and couldn't find anything wrong with
> them, and for larks tried applying
> cpumask-disable-offstack-on-rt.patch from v3.2-rt10
> all to no avail, the problem is still there.

What a surprise, it's completely unrelated.
--8323328-1286624960-1327489340=:2716--
