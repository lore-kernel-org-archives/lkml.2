Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2BGI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:29:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab2BGI3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:29:15 -0500
Date: Tue, 7 Feb 2012 09:29:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH] sched: move CONFIG_IRQ_TIME_ACCOUNTING to common code
Message-ID: <20120207082907.GB12821@elte.hu>
References: <1328080789-18277-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328080789-18277-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Dmitry Antipov <dmitry.antipov@linaro.org> wrote:

> Since CONFIG_IRQ_TIME_ACCOUNTING is architecture-agnostic, 
> move it from x86 area to common code.
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  arch/x86/Kconfig  |   11 -----------
>  lib/Kconfig.debug |   11 +++++++++++
>  2 files changed, 11 insertions(+), 11 deletions(-)

That's not enough, right now on x86 this code needs special 
architecture glue, see how the noirqtime flag is used to call 
into enable_sched_clock_irqtime() after TSC init.

So if you apply your patch and boot CONFIG_IRQ_TIME_ACCOUNTING=y 
on say an ARM system, nothing will be done, because 
sched_clock_irqtime is always zero.

Thanks,

	Ingo
