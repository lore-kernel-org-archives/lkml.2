Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0CQJzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:55:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0CQJzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:55:07 -0400
Date: Wed, 17 Mar 2010 10:54:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: T??r??k Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit
 kernels V3.
Message-ID: <20100317095456.GE17146@elte.hu>
References: <4BA09776.4020205@gmail.com>
 <1268815776-29501-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268815776-29501-1-git-send-email-edwintorok@gmail.com>
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


* T??r??k Edwin <edwintorok@gmail.com> wrote:

> +#ifdef CONFIG_COMPAT
> +	if (test_thread_flag(TIF_IA32)) {
> +		perf_callchain_user32(regs, entry);
> +		return;
> +	}
> +#endif

You can push that test into perf_callchain_user32() and turn it into something 
like:

	if (perf_callchain_user32(regs, entry))
		return;

without the #ifdef here.

	Ingo
