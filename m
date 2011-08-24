Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1HXN7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:59:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50421 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1HXN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:58:59 -0400
Date: Wed, 24 Aug 2011 15:58:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steevven1 <steevven1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Bug Report for Linux Kernel 3.x
Message-ID: <20110824135852.GE23979@somewhere>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
 <20110824001137.GA23979@somewhere>
 <CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't top-post)

On Tue, Aug 23, 2011 at 08:21:50PM -0400, Steevven1 wrote:
> QUICK NOTE - Thanks for replying directly to me as well as the mailing
> list. I am NOT on that mailing list. Please continue to do this.
> 
> That is correct about sparse irq. That was causing the first problem,
> and solving that did in fact result in better power performance, but
> it was apparently NOT the bulk of the problem.
> 
> We still have no diagnosis at all for the apparently still-present
> other (mystery) problem. Powertop now reports to me very low processor
> wakeups (basically the same as the 2.6-series kernels), which
> indicates to me that the problem is PROBABLY not related to processor
> wakeups. I am by no means an expert. The top wakeup-causers with the
> modified 3.0 kernel (no sparse irq) and an idle system are "[iwlagn]
> <interrupt>" (wifi), "[i915] <interrupt>" (I don't know what this is),
> and "[kernel scheduler] Load balancing tick"
> 
> P-states/frequencies are handled about the same as with the 2.6
> kernels, so I don't see a problem there either.
> 
> What else can I check? It seems like powertop is telling me nothing
> about this mystery power drain.

Well, if powertop has nothing to tell about that, I have no clue where
to go. I'm adding more people in Cc in the hope they can be more
helpful.

> 
> 
> On Tue, Aug 23, 2011 at 8:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Aug 23, 2011 at 07:19:35PM -0400, Steevven1 wrote:
> >> Hello,
> >>
> >> I would like to report what myself and several others believe to be a
> >> serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
> >> (2.6.x and lower).
> >>
> >> One-sentence description: On certain hardware, the 3.x series kernels
> >> drain a considerable amount more power than the 2.6-series kernels, up
> >> to 40% more, even when idle.
> >>
> >> The specific hardware I have personally tested is a Lenovo ThinkPad
> >> X220 with an Intel SandyBridge i7 2620M processor. We think that this
> >> bug is POSSIBLY specific to this processor, or family of processors,
> >> commonly used in notebooks. A complete thread of mine and others'
> >> results, evidence, and troubleshooting process is located at:
> >> http://ubuntuforums.org/showthread.php?t=1822629
> >>
> >> We have tried several different 3.0 and 3.1-series kernels, all with
> >> the same problems. One part of the problem was that the following
> >> (revealed by powertop) was causing excessive processor wakeups
> >> compared to the 2.6-series kernels: "[Rescheduling interrupts] <kernel
> >> IPI>"
> >>
> >> Someone much more advanced than I figured out how to eliminate this
> >> problem and recompiled the kernel (which he posted in the thread I
> >> linked to previously), but power usage is still improved only
> >> slightly, nowhere near kernel 2.6 levels.
> >>
> >> There is a lot more information I could give you here, but all of it
> >> is contained within the thread I linked to. If you have any specific
> >> questions, I will answer as quickly as possible.
> >>
> >> Thanks a lot for your assistance. Please confirm that you received this email.
> >>
> >> Steven Keys!
> >
> > Hi Steve,
> >
> >
> > You said the problem with rescheduling interrupt disappeared but you
> > haven't said why. After reading the thread it seems it was about
> > Sparse irq config beeing enabled? And that disappeared after
> > sparse irq got disabled?
> >
> > If so that looks like a first bug.
> >
> > Also now that you don't see that problem anymore but still
> > a problem with power consumption, what does powertop report to
> > you?
> >
> > Thanks.
> >
