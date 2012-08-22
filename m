Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab2HVJDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:03:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63343 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2HVJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:03:10 -0400
Date: Wed, 22 Aug 2012 11:03:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822090304.GA23336@gmail.com>
References: <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
 <20120821182346.GA7325@gmail.com>
 <20120821195234.20c173bc@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821195234.20c173bc@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Why? Good scheduling is useful even in isolation.
> 
> For power - I suspect it's damn near irrelevant except on a 
> big big machine.

With deep enough C states it's rather relevant whether we 
continue to burn +50W for a couple of more milliseconds or not, 
and whether we have the right information from the scheduler and 
timer subsystem about how long the next idle period is expected 
to be and how bursty a given task is.

'Balance for energy efficiency' obviously ties into the C state 
and frequency selection logic, which is rather detached right 
now, running its own (imperfect) scheduling metrics logic and 
doing pretty much the worst possible C state and frequency 
decisions in typical everyday desktop workloads.

> Unless you've sorted out your SATA, fixed your phy handling, 
> optimised your desktop for wakeups and worked down the big 
> wakeup causes one by one it's turd polishing.
> 
> PM means fixing the stack top to bottom, and its a whackamole 
> game, each one you fix you find the next. You have to sort the 
> entire stack from desktop apps to kernel.

Moving 'policy' into user-space has been an utter failure, 
mostly because there's not a single project/subsystem 
responsible for getting a good result to users. This is why
I resist "policy should not be in the kernel" meme here.

> However benchmarks talk - so lets have some benchmarks ... on 
> a laptop.

Agreed.

Thanks,

	Ingo
