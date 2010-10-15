Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0JOHtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:49:36 -0400
Received: from canuck.infradead.org ([134.117.69.58]:34813 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0JOHtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:49:35 -0400
Subject: Re: [REGRESSION] um: rcu_sched_state detected stall on CPU 0
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>, penberg@cs.helsinki.fi,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>
In-Reply-To: <AANLkTi=vYFv+S=D6O06Nys4cjU7KHWv11d_VdLGmLyf6@mail.gmail.com>
References: <AANLkTinNxzktyttzEjWSUPBiOUwh+4DUL0tmP7p1UiT5@mail.gmail.com>
	 <4CB75F05.9070505@linux.intel.com>
	 <AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP@mail.gmail.com>
	 <AANLkTi=vYFv+S=D6O06Nys4cjU7KHWv11d_VdLGmLyf6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 09:48:48 +0200
Message-ID: <1287128928.29097.1235.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 10:02 +0300, Pekka Enberg wrote:
> On Fri, Oct 15, 2010 at 2:44 AM, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
> > On Thu, Oct 14, 2010 at 9:50 PM, Arjan van de Ven
> <arjan@linux.intel.com> wrote:
> >>  On 10/14/2010 11:27 AM, richard -rw- weinberger wrote:
> >>>
> >>> Hi Arjan!
> >>>
> >>> This commit causes some problems on UML.
> >>>
> >> that is extremely weird.
> >>>
> >>> The kernel freezes after a few seconds until it gets some input.
> >>> e.g: When I run top it stops refreshing the process list until i
> press a
> >>> button.
> >>
> >> a slab timer change (to not be as critical) causing global timer
> issues....
> >> that's very obviously not a problem with this patch.
> >> has this been seem anywhere except UML ?
> >
> > A small update:
> > It seems that CONFIG_NO_HZ is broken on UML. :-(
> >
> > CONFIG_NO_HZ + CONFIG_SLAB: works
> > CONFIG_NO_HZ + CONFIG_SLAB + your patch: broken
> > CONFIG_NO_HZ + CONFIG_SLUB: broken
> >
> > CONFIG_SLAB + your patch: works
> > CONFIG_SLAB: works
> > CONFIG_SLUB: works
> 
> Thanks for testing! Thomas, Ingo, Peter, I'm not sure who maintains
> CONFIG_NO_HZ so I CC'd you. The problem here is that Arjan's
> deferrable timers patch in SLAB triggered something that looks like a
> latent bug with UML and NOHZ. 

Thomas does mostly, but if its UML specific, I guess its Jeff Dike
you'll be wanting to talk to, since he's the arch maintainer.


