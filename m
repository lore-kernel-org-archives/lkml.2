Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1JJRPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:15:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48293 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1JJRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:15:41 -0400
Date: Mon, 10 Oct 2011 19:14:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tj@kernel.org" <tj@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111010171437.GA11907@elf.ucw.cz>
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
 <4E931018.8030904@linux.vnet.ibm.com>
 <20111010165343.GA29261@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010165343.GA29261@aftab>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The seems like entirely the wrong way to go about solving this problem.
> > > 
> > > The kernel shouldn't be responsible for making hotplug stress tests 
> > > exclusive with system sleep.  Whoever is running those tests should be 
> > > smart enough to realize what's wrong if system sleep interferes with a 
> > > test.
> 
> Yes, agreed. And more: I'm still trying to understand why a test case
> like that is relevant and needs to be fixed at all. Let me re-formulate
> the question: what real world scenario(s) does the case of hibernating
> _while_ off- and onlining cores cover? Or are you simply doing kernel
> resiliency testing and thought that offlining cores while hibernating
> might make sense?

Some people want to do hibernate on battery low / UPS fail. That can
happen any time...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
