Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1DVIVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:21:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1DVIVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:21:04 -0400
Date: Fri, 22 Apr 2011 10:20:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] perf, x86: P4 PMU -- Use perf_sample_data_init helper
Message-ID: <20110422082048.GB24011@elte.hu>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
 <1303398203-2918-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303398203-2918-2-git-send-email-dzickus@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> From: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> Instead of opencoded assignments better to use
> perf_sample_data_init helper.
> 
> Tested-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
> index c2520e1..6f2bd89 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
>  	int idx, handled = 0;
>  	u64 val;
>  
> -	data.addr = 0;
> -	data.raw = NULL;
> +	perf_sample_data_init(&data, 0);

This one sure can wait for v2.6.40, right?

Thanks,

	Ingo
