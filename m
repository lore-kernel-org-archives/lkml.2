Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0DVM6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 08:58:09 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42950 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754629Ab0DVM6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 08:58:07 -0400
Date: Thu, 22 Apr 2010 07:58:00 -0500
From: Jack Steiner <steiner@sgi.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Rik van Riel <riel@redhat.com>,
       John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
Message-ID: <20100422125800.GA22285@sgi.com>
References: <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com> <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422102852.72837494@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 10:28:52AM +0100, Alan Cox wrote:
> > Distros don't want to take a patch that adds a new boot param that is
> > not accepted upstream, otherwise they will be stuck forward porting it
> > from now until, well, forever :)
> 
> So for an obscure IA64 specific problem you want the upstream kernel to
> port it forward forever instead ?

FWIW, the problem is occurring on systems that use x86 processors - not
IA64.


> > 
> > As this solves a problem that people are having today, on the kernel.org
> > kernel, on a known machine, and we really don't know when the "reduce
> > the number of processes per cpu" work will be done, or if it really will
> > solve this issue, then why can't we take it now?  If the work does solve
> > the problem in the future, then we can take the command line option out,
> > and everyone is happy.
> > 
> > Sound reasonable?
> 
> No - to start with it would be far saner for everything involved if the
> 4096 processor minority fixed it for the moment in their arch code by
> doing something like
> 
> 	if (max_pids < PIDS_PER_CPU * num_cpus) {
> 		max_pids = ...
> 		printk(something informative)
> 	}
> 
> in their __init marked code.
> 
> Because when Tejun's stuff is in the patch can go away, and also if it's
> not sufficient then the patch above should keep it sane when they go to
> 32000 cpus or whatever is next.
> 
> Alan
