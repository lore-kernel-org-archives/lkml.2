Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1GUH1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:27:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1GUH1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:27:42 -0400
Date: Thu, 21 Jul 2011 09:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110721072656.GF9216@elte.hu>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
 <1310655837-328-4-git-send-email-fweisbec@gmail.com>
 <4E1F5EF3.6050601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1F5EF3.6050601@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/14/2011 08:03 AM, Frederic Weisbecker wrote:
> > So that hw_breakpoints and perf can be not built on
> > specific embedded systems.
> 
> I want to emphasize I am very, very unhappy about this.  It should 
> be possible to not build perf while still have breakpoints 
> available... breakpoints are way more important than perf.

What we could indeed do is to separate out a 'core perf' portion that 
is necessary for hw-breakpoints to work fine, thus allowing for 
example the PMU drivers to be disabled.

Otherwise we have expressed hw breakpoint APIs via perf events and 
that model is working well. Making hw-breakpoints a separate 
subsystem again with isolated (and partly duplicated) infrastructure 
would be a step back really.

Thanks,

	Ingo
