Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2CGODI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:03:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab2CGODG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:03:06 -0500
Date: Wed, 7 Mar 2012 15:02:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        prashanth@linux.vnet.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "paulmck@linux.vnet.ibm.com >> \"Paul E. McKenney\"" 
	<paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
Message-ID: <20120307140246.GC12676@elte.hu>
References: <20120306204357.13169.90791.stgit@zurg>
 <4F5763CD.8050903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5763CD.8050903@linux.vnet.ibm.com>
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


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> On 03/07/2012 02:15 AM, Konstantin Khlebnikov wrote:
> 
> > This is fix for suspend/resume regression introduced in 
> > commit 8f2f748b0656 ("CPU hotplug, cpusets, suspend: Don't 
> > touch cpusets during suspend/resume") Without this patch 
> > suspend always hangs on my thinkpad x220 (2 x CPU * HT).
> 
> 
> Hey, with commit 8f2f748b0656, suspend/resume works perfectly 
> for me! I ran it multiple times just to make sure, and 
> everything worked just great.
>
> Apart from that, I even tried suspend/resume after building 
> the kernel with and without CONFIG_CPUSETS. Both cases worked 
> perfectly.
> 
> So, I am really surprised at what you stated above. Are you 
> *really* sure you are facing suspend hangs *because* of the 
> above commit?

That's not the only information Konstantin gave: he also 
provided a patch, which activates a side-effect that got removed 
by your patch - and voila, s2ram was working for him again.

At this point I don't think we should doubt the messenger, we 
should doubt our assumptions and we should go for a clean revert 
ASAP.

I don't see the underlying bug straight away, but clearly my 
assumptions of this patch not causing problems, when I applied 
the patch, are not valid anymore.

So if Linus wants to revert the commit straight away:

Acked-by: Ingo Molnar <mingo@elte.hu>

> And AFAICS hardware doesn't matter for the code in question, but in any case,
> the laptop on which I tested it is:
> Thinkpad T420 (Intel core i5-2540M), 2 cores * HT (total 4 logical cpus).

Well, any environmental detail might matter as long as we don't 
understand the bug.

> Also, the patch you posted here doesn't make much sense.. nor 
> does it give a clue as to what might be wrong at your end (if 
> anything is really wrong, that is). Do you have CONFIG_CPUSETS 
> set or unset? Could you share your .config?

His patch is simply the re-creation of a side-effect that the 
kernel had before - and it made suspend work for him. While it 
is not a patch we want to apply, it sure was a valid and 
valuable experiment to perform.

Thanks,

	Ingo
