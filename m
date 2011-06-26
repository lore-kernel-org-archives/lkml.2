Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1FZKrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 06:47:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab1FZKpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 06:45:32 -0400
Date: Sun, 26 Jun 2011 12:45:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rfc patch] x86,apic: fix DEBUG_PREEMPT gripe when booting with
 threadirqs=1
Message-ID: <20110626104521.GE11093@elte.hu>
References: <1308743825.8568.3.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308743825.8568.3.camel@marge.simson.net>
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


* Mike Galbraith <mgalbraith@suse.de> wrote:

> x86,apic: fix DEBUG_PREEMPT gripe when booting with threadirqs=1
> 
> If CONFIG_PREEMPT and CONFIG_INTR_REMAP are both set, and a box is
> booted with threadirqs, the gripe below is emitted.  It was suggested
> that native_smp_prepare_cpus() shouldn't need to be run with preemption
> disabled, and indeed, box boots with no hint of trouble.  Remove it.

Would also require a careful review of the code we take out of 
preempt protection now - have you done that by any chance? (if not, 
mind doing it?)

Thanks,

	Ingo
