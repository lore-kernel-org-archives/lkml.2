Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1EWLSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:18:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47501 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1EWLSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:18:43 -0400
Date: Mon, 23 May 2011 13:18:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf tools fixes
Message-ID: <20110523111838.GA352@elte.hu>
References: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
 <20110523111333.GA28985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523111333.GA28985@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Ingo,
> > 
> > Please pull the perf/urgent branch that can be found at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	perf/urgent
> > 
> > Thanks,
> > 	Frederic
> > ---
> > 
> > Frederic Weisbecker (2):
> >       perf tools: Fix sample size bit operations
> >       perf tools: Fix ommitted mmap data update on remap
> > 
> > 
> >  tools/perf/util/event.c   |    2 +-
> >  tools/perf/util/session.c |   39 ++++++++++++++++++++++++++-------------
> >  2 files changed, 27 insertions(+), 14 deletions(-)

Hm, you broke perf top:

   PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [1000Hz cycles],  (all, 16 CPUs)
-------------------------------------------------------------------------------------------------------

             samples  pcnt  DSO
             _______ _____  

Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14
Can't parse sample, err = -14

and perf record+report as well:

aldebaran:~/linux/linux> perf record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.119 MB perf.data (~5201 samples) ]
aldebaran:~/linux/linux> perf report --stdio
The perf.data file has no samples!

so i'm unpulling these bits.

Thanks,

	Ingo
