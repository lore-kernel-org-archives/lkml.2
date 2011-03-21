Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1CUSFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:05:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab1CUSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:05:34 -0400
Date: Mon, 21 Mar 2011 19:05:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321180526.GB4849@elte.hu>
References: <20110321160135.GA31562@sgi.com>
 <20110321161425.GC23614@elte.hu>
 <20110321165608.GA12718@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321165608.GA12718@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
> +	int handled;
>  
>  	/*
>  	 * CPU-specific NMI must be processed before non-CPU-specific
>  	 * NMI, otherwise we may lose it, because the CPU-specific
>  	 * NMI can not be detected/processed on other CPUs.
>  	 */
> -	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> +	handled = x86_platform.nmi_handler(regs);
> +	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
> +	    			handled)
>  		return;

This would indeed be cleaner and would work better - given how unreliable it is 
to demultiplex NMI reasons.

Thanks,

	Ingo
