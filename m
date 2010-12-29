Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0L2RCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 12:02:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0L2RCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 12:02:38 -0500
Date: Wed, 29 Dec 2010 17:37:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.37
Message-ID: <20101229163743.GA27109@elte.hu>
References: <20101229144702.GL4739@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101229144702.GL4739@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile fixes for v2.6.37 (tip/perf/urgent):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> (uploaded but not yet sync'ed until now)
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit e1e359273576ee8fe27021356b064c772ed29af3:
> 
>   ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page (2010-12-23 12:09:30 -0500)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> Andrew Morton (1):
>       arch/x86/oprofile/op_model_amd.c: perform initialisation on a single CPU
> 
>  arch/x86/oprofile/op_model_amd.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Hm, i'm not sure this fix is correct:

 static int op_amd_init(struct oprofile_operations *ops)
 {
+       /*
+        * init_ibs() preforms implictly cpu-local operations, so pin this
+        * thread to its current CPU
+        */
+       preempt_disable();
        init_ibs();
+       preempt_enable();

If init_ibs() is indeed CPU local, then it needs to be called on all CPUs.
Does that happen and if not why not? AFAICS it's only called on one CPU.

Thanks,

	Ingo
