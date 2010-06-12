Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0FLK0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 06:26:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0FLK0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 06:26:13 -0400
Date: Sat, 12 Jun 2010 12:25:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100612102558.GA4000@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2453]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> NMI can be triggered even when IRQ is masked. So it is not safe for NMI 
> handler to call some functions. One solution is to delay the call via self 
> interrupt, so that the delayed call can be done once the interrupt is 
> enabled again. This has been implemented in MCE and perf event. This patch 
> provides a unified version and make it easier for other NMI semantic handler 
> to take use of the delayed call.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/include/asm/entry_arch.h  |    1 
>  arch/x86/include/asm/hw_irq.h      |    1 
>  arch/x86/include/asm/irq_vectors.h |    5 +
>  arch/x86/include/asm/nmi.h         |    7 ++
>  arch/x86/kernel/entry_64.S         |    3 +
>  arch/x86/kernel/irqinit.c          |    3 +
>  arch/x86/kernel/traps.c            |  104 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 124 insertions(+)

Instead of introducing this extra intermediate facility please use the same 
approach the unified NMI watchdog is using (see latest -tip): a perf event 
callback gives all the extra functionality needed.

The MCE code needs to be updated to use that - and then it will be integrated 
into the events framework.

Thanks,

	Ingo
