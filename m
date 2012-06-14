Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2FNLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:16:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54076 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab2FNLQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:16:55 -0400
Date: Thu, 14 Jun 2012 13:16:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
Message-ID: <20120614111638.GA16676@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614111241.GA16848@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jun 14, 2012 at 11:07:09AM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-13 at 18:19 +0200, Frederic Weisbecker wrote:
> > > Ingo, Thomas,
> > > 
> > > This starts the basic code that allow accounting of cputime spent tickless
> > > outside idle, which is a first step to prepare for the adaptive nohz
> > > infrastructure.
> > > 
> > > I hope we can set a tree in -tip for that. If you're fine with it
> > > this is pullable from:
> > 
> > There's a number of architecture that already does fine grained
> > user/kernel time accounting on syscall boundaries etc.. s390, powerpc
> > and ia64.
> > 
> > You're now adding a 3rd way of accounting user/kernel time.. I'm not
> > much looking fwd to that..
> 
> You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> and see if I can reuse it.
> 
> I'll try something with that.

Maybe sanitize all the variants under a single set of 
wrappers/callbacks?

Thanks,

	Ingo
