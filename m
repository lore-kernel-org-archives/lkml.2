Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab0KGLnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 06:43:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48426 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0KGLnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 06:43:16 -0500
Date: Sun, 7 Nov 2010 12:42:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107114237.GA3759@elte.hu>
References: <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
 <20101107085016.GA23843@elte.hu>
 <20101107094932.GT4627@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107094932.GT4627@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> [...] I was explaining that doing this will not prevent them from guessing the 
> precise kernel version, [...]

Well, which is exactly what i have said to Marcus early on in this discussion:

 |
 | What i suggested in later parts of my mail might provide more security: to sandbox 
 | kernel version information from unprivileged user-space - if we decide that we 
 | want to sandbox kernel version information ...
 |
 | That is a big if, because it takes a considerable amount of work. Would be worth 
 | trying it - but feel-good non-solutions that do not bring much improvement to the 
 | majority of users IMHO hinder such efforts.
 |

The 'considerable amount of work' refers not to the utsname version fuzzing patch 
(it's a 10-liner patch, literally), but to controlling the channels of version 
information you mentioned (uptime, the /boot timestamp), and some other channels you 
did not mention: dmesg, various /sys and /proc entries that leak version 
information, etc.

All must be closed down for unprivileged user-space, for this to be effective, 
obviously.

( Note that there will also be some channels of information that cannot
  realistically be closed down (such as the presence of sys_perf_event_open()
  indicates a v2.6.32+ kernel - or a backported, patched kernel) - but what matters
  mostly is to fuzz the _precise_ version information, to inject uncertainty into
  the equation of attackers. Combined with honeypot silent alarm functionality it
  turns the equation around and creates an outright risk of detection. )

Thanks,

	Ingo
