Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2COHWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:22:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39922 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2COHWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:22:48 -0400
Date: Thu, 15 Mar 2012 08:21:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Benjamin Segall <bsegall@google.com>,
        Ranjit Manomohan <ranjitm@google.com>, Nikhil Rao <ncrao@google.com>,
        jmc@cs.unc.edu, Dhaval Giani <dhaval.giani@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] LinSched for v3.3-rc7
Message-ID: <20120315072124.GA29161@elte.hu>
References: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Turner <pjt@google.com> wrote:

> That said, I'm relatively happy with the current state of 
> integration, there's certainly some specific areas that can 
> still be greatly improved (in particular, the main simulator 
> loop has not had as much attention paid as the 
> LinSched<>Kernel interactions and there's a long list of TODOs 
> that could be improved there), but things are now mated fairly 
> cleanly through the use of a new LinSched architecture.  This 
> is a total re-write of almost all LinSched<>Kernel 
> interactions versus the previous (2.6.35) version, and has 
> allowed us to now carry almost zero modifications against the 
> kernel source.  It's both possible to develop/test in place, 
> as well as being patch compatible.  The remaining touch-points 
> now total just 20 lines!  Half of these are likely mergable, 
> with the other 10 lines being more LinSched specific at this 
> point in time, I've broken these down below:
> 
> The total damage:
>  include/linux/init.h      |    6 ++++++   (linsched ugliness,
> unfortunately necessary until we boot-strap proper initcall support)
>  include/linux/rcupdate.h  |    3 +++    (only necessary to allow -O0
> compilation which is extremely handy for analyzing the scheduler using
> gdb)
>  kernel/pid.c              |    4 ++++        (linsched ugliness,
> these can go eventually)
>  kernel/sched/fair.c       |    2 +-          (this is just the
> promotion of 1 structure and function from static state which weren't
> published in the sched/ re-factoring that we need from within the
> simulator)
>  kernel/sched/stats.c      |    2 +-
>  kernel/time/timekeeping.c |    3 ++-    (this fixes a time-dilation
> error due to rounding when our clock-source has ns-resolution, e.g.
> shift==1)
>  6 files changed, 17 insertions(+), 3 deletions(-)

Mind sending these preparatory changes as a standalone series as 
well, against the upstream scheduler, straight away?

Maybe we can find ways to remove the uglies while reviewing and 
integrating all that. Having those bits upstream would make the 
rest of linsched a lot easier to merge as well.

Thanks,

	Ingo
