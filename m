Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab1HEKrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:47:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1HEKri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:47:38 -0400
Date: Fri, 5 Aug 2011 12:46:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, davej@redhat.com, yinghan@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110805104635.GB13055@elte.hu>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801184542.GA3939@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> +/*
> + * Check if another cpu is in the same socket and has already been calibrated.
> + * If found, use the previous value. This assumes all cores in the same physical
> + * socket have the same core frequency.
> +
> +unsigned long __cpuinit calibrate_delay_is_known(void)
> +{
> +	int i, cpu = smp_processor_id();
> +
> +	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
> +		return 0;
> +
> +	for_each_online_cpu(i)
> +		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
> +			return cpu_data(i).loops_per_jiffy;

Hm, why do we have to make such an assumption? Cannot we query the 
core frequency?

Thanks,

	Ingo
