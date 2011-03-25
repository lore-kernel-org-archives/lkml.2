Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1CYTXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:23:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1CYTXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:23:21 -0400
Date: Fri, 25 Mar 2011 20:23:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, efault@gmx.de, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf, x86: Complain louder about BIOSen
 corrupting CPU/PMU state and continue
Message-ID: <20110325192303.GB22960@elte.hu>
References: <tip-45daae575e08bbf7405c5a3633e956fa364d1b4f@git.kernel.org>
 <AANLkTi=Dgo7Ck-Nc+qq7roRqcO9mtoA_FLt=QA6mdK_W@mail.gmail.com>
 <1301073100.2250.229.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301073100.2250.229.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > This might also be something we do want to give a kernel command line
> > option for. As in "bios=allow-annoying-pmu-thing" or whatever.
> 
> I had such a patch, Ingo argued against it and we decided not to do it,
> but we could still.

Basically for many kernel releases we ignored the BIOS corrupting the PMU - so 
one could fairly argue that this patch fixes a perf functionality regression 
for Eric. We'll still warn in the syslog about the BIOS so there's an 
indication that something is going on.

Linus, which variant is the most efficient one in your opinion? I'm leaning 
slightly in favor of this patch in perf/urgent: it restores Eric's system to 
the before-BIOS-corruption-detection state, but also warns about the BIOS 
craziness.

	Ingo
