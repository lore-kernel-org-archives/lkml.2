Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1FGXmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:42:42 -0400
Received: from hofr.at ([212.69.189.236]:47959 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab1FGXml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:42:41 -0400
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 19:42:40 EDT
Date: Wed, 8 Jun 2011 01:35:18 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Remy Bohmer <linux@bohmer.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
Message-ID: <20110607233517.GA31794@opentech.at>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de> <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jun 2011, Remy Bohmer wrote:

> Hi All,
> 
> 2011/6/7 Peter Zijlstra <peterz@infradead.org>:
> > On Tue, 2011-06-07 at 11:40 +0200, Armin Steinhoff wrote:
> >> Hi,
> >>
> >> when I read all these confusing statements here ( in german it looks
> >> like an "Eiertanz") ?... I can only say:
> >>
> >> - do the basic stuff in a minimal kernel driver
> >> - use UIO (or VFIO for PCI devices)
> >
> > I see no requirement for any of those horrid things to be used. You can
> > write a full on proper kernel driver, it just cannot set kernel thread
> > priorities to a sane value (let them all default to 50 or so).
> >
> > Then have a user space script or whatever set the kthread priorities.
> >> and you get clean control about your real-time priorities.
> >> I think changing the priorities of "interrupt threads" inside the kernel
> >> could lead to strange race conditions in the kernel.
> 
> Well, I 100% agree that it must be under full userspace control to be
> able to set the priorities. But, the kernel default assumption of
> starting everything at 50 is wrong as well.
> Imagine the following situation:
> * Realtime application is running and has threads active in the range
> of prios 20 - 90.
> * Now bring up a network device, it immediately starts spamming the
> system at prio 50 _before_ you have the chance to set it below 20 by
> means of chrt.
> * RT behaviour is gone!
> 
> So, in that case and in many other hotplug cases, you ruin the RT
> behaviour of the system just by the
> default-50-is-probably-right-assumption of the kernel.
> For systems where you have everything under control as a user/system
> designer, hotplug can also be under control as well.
>

I dont't quite see that - the 50 default is well dokumented so you can
plan it into the rt design at system level. It simply means that you
would need to put your hard-rt tasks in the range of 50<prio<99. 

The actual value is quite irrelevant aslong as it is well defined, and 
leaves a range free above suitably large for a rt task set (if you need
more than 5 distinct priorities for a rt task-set it generally means you
are using implicid locking any way)

I dont see the utility of adding a further interface that provides the same
level of configuration that the current user space tools do, and having one
interface for interrupt threads and one for tasks does not really simplify
things - from a rt-task-set perspective the differentiation betwen rt-tasks
and rt-related interrupt threads does not really make sens so keeping the
management in one interface seems more resonable to me.

hofrat 
