Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0CQRxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:53:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0CQRxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:53:18 -0400
Date: Wed, 17 Mar 2010 18:53:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Fix holdoff for accelerated GPs for last
 non-dynticked CPU
Message-ID: <20100317175311.GA5187@elte.hu>
References: <1267311188-16603-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <tip-622ea685f1fafdf84d612440535c84341f0860b8@git.kernel.org>
 <20100316110036.GA4554@elte.hu>
 <20100316110323.GA31038@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316110323.GA31038@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> incidentally i have a RCU badness crash log from another box:
> 
> [    4.573332] initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 0 usecs                 
> [    4.573332] calling  init_ipmi_si+0x0/0x435 @ 1
> [    4.573332] IPMI System Interface driver.
> [    4.573340]  [<ffffffff81022cdc>] no_context+0x1fc/0x20b
> [    4.576672]  [<ffffffff81002a16>] ? ftrace_call+0x5/0x2b
> [    4.580021]  [<ffffffff81022e77>] __bad_area_nosemaphore+0x18c/0x1af
> [    4.583338]  [<ffffffff81002a16>] ? ftrace_call+0x5/0x2b
> [    4.586672]  [<ffffffff81022ead>] bad_area_nosemaphore+0x13/0x15
> [    4.590005]  [<ffffffff81023159>] do_page_fault+0x138/0x284
> [    4.593354]  [<ffffffff81a632bf>] page_fault+0x1f/0x30

I spent a few hours yesterday and today trying to track this down, but failed 
to bisect it. The crash is sporadic on many configs - which confused my 
bisection attempts. Sometimes it crashes only after 10 reboots. Was able to 
crash v2.6.30 as well, so it's an older bug. v2.6.29 was not testable on that 
box due to network driver problems so i stopped there.

	Ingo
