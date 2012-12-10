Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab2LJTcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:32:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab2LJTcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:32:23 -0500
Date: Mon, 10 Dec 2012 19:32:19 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [GIT TREE] Unified NUMA balancing tree, v3
Message-ID: <20121210193219.GM1009@suse.de>
References: <1354839566-15697-1-git-send-email-mingo@kernel.org>
 <alpine.LFD.2.02.1212101902050.4422@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212101902050.4422@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 07:22:37PM +0100, Thomas Gleixner wrote:
> On Fri, 7 Dec 2012, Ingo Molnar wrote:
> > The SPECjbb 4x JVM numbers are still very close to the
> > hard-binding results:
> > 
> >   Fri Dec  7 02:08:42 CET 2012
> >   spec1.txt:           throughput =     188667.94 SPECjbb2005 bops
> >   spec2.txt:           throughput =     190109.31 SPECjbb2005 bops
> >   spec3.txt:           throughput =     191438.13 SPECjbb2005 bops
> >   spec4.txt:           throughput =     192508.34 SPECjbb2005 bops
> >                                       --------------------------
> >         SUM:           throughput =     762723.72 SPECjbb2005 bops
> > 
> > And the same is true for !THP as well.
> 
> I could not resist to throw all relevant trees on my own 4node machine
> and run a SPECjbb 4x JVM comparison. All results have been averaged
> over 10 runs.
> 
> mainline:	v3.7-rc8
> autonuma:	mm-autonuma-v28fastr4-mels-rebase
> balancenuma:	mm-balancenuma-v10r3
> numacore:	Unified NUMA balancing tree, v3
> 
> The config is based on a F16 config with CONFIG_PREEMPT_NONE=y and the
> relevant NUMA options enabled for the 4 trees.
> 

Ok, I had PREEMPT enabled so we differ on that at least. I don't know if
it would be enough to hide the problems that led to the JVM crashing on
me for the latest version of numacore or not.

> THP off: manual placement result:     125239
> 
> 		Auto result	Man/Auto	Mainline/Auto	Variance
> mainline    :	     93945	0.750		1.000		 5.91%
> autonuma    :	    123651	0.987		1.316		 5.15%
> balancenuma :	     97327	0.777		1.036		 5.19%
> numacore    :	    123009	0.982		1.309		 5.73%
> 
> 
> THP on: manual placement result:     143170
> 
> 		Auto result	Auto/Manual	Auto/Mainline	Variance
> mainline    :	    104462	0.730		1.000		 8.47%
> autonuma    :	    137363	0.959		1.315		 5.81%
> balancenuma :	    112183	0.784		1.074		11.58%
> numacore    :	    142728	0.997		1.366		 2.94%
> 
> So autonuma and numacore are basically on the same page, with a slight
> advantage for numacore in the THP enabled case. balancenuma is closer
> to mainline than to autonuma/numacore.
> 

I would expect balancenuma to be closer to mainline than autonuma, whatever
about numacore which I get mixed results for. balancenumas objective was
not to be the best, it was meant to be a baseline that either autonuma
or numacore could compete based on scheduler policies for while the MM
portions would be common to either. If I thought otherwise I would have
spent the last 2 weeks working on the scheduler aspects which would have
been generally unhelpful.

-- 
Mel Gorman
SUSE Labs
