Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2FNNmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:42:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59154 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2FNNmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:42:52 -0400
Date: Thu, 14 Jun 2012 15:42:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
Message-ID: <20120614134238.GD16848@somewhere>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
 <20120614111638.GA16676@gmail.com>
 <alpine.LFD.2.02.1206141321010.3086@ionos>
 <20120614112241.GB16848@somewhere>
 <20120614144815.1401af49@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614144815.1401af49@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 02:48:15PM +0200, Martin Schwidefsky wrote:
> On Thu, 14 Jun 2012 13:22:45 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Jun 14, 2012 at 01:21:23PM +0200, Thomas Gleixner wrote:
> > > On Thu, 14 Jun 2012, Ingo Molnar wrote:
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> > > > > and see if I can reuse it.
> > > > > 
> > > > > I'll try something with that.
> > > > 
> > > > Maybe sanitize all the variants under a single set of 
> > > > wrappers/callbacks?
> > > 
> > > Yes, please!
> > 
> > Sure, I'm working in it.
>  
> Please keep me in the loop, I want to avoid that things break on s390. Thanks.

Do you have any idea why s390 counts idle time from asm deep in the idle code
rather than just hooking in account_system_vtime() like ppc or ia64?
