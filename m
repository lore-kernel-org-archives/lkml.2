Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1FMT4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:56:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40654 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516Ab1FMT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:56:29 -0400
Date: Mon, 13 Jun 2011 21:56:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, hpa@zytor.com, trenn@novell.com, prarit@redhat.com,
        tj@kernel.org, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        youquan.song@intel.com, stable@kernel.org
Subject: Re: [patch v4 1/2] stop_machine: enable __stop_machine() to be
 called from the cpu online path
Message-ID: <20110613195613.GA11196@elte.hu>
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
 <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Currently stop machine infrastructure can be called only from a cpu that is
> online. But for !CONFIG_SMP, we do allow calling __stop_machine() before the
> cpu is online.
> 
> x86 for example requires stop machine infrastructure in the cpu online path
> and currently implements its own stop machine (using stop_one_cpu_nowait())
> for MTRR initialization in the cpu online path.
> 
> Enhance the __stop_machine() so that it can be called before the cpu
> is onlined. This will pave the way for code consolidation and address potential
> deadlocks caused by multiple mechanisms of doing system wide rendezvous.
> 
> This will also address the behavioral differences of __stop_machine()
> between SMP and UP builds.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org    # v2.6.35+
> ---
>  include/linux/stop_machine.h |   11 +++--
>  kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 93 insertions(+), 9 deletions(-)

Btw., this is *way* too risky for a -stable backport.

Thanks,

	Ingo
