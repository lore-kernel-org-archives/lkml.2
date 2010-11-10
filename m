Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0KJHuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:50:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0KJHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:50:04 -0500
Date: Wed, 10 Nov 2010 08:49:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        sergey.senozhatsky@gmail.com
Subject: Re: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch local
 cpu not every one
Message-ID: <20101110074941.GD29493@elte.hu>
References: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289240913-16677-1-git-send-email-dzickus@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> I ran into a scenario where while one cpu was stuck and should have panic'd 
> because of the NMI watchdog, it didn't.  The reason was another cpu was spewing 
> stack dumps on to the console.  Upon investigation, I noticed that when writing to 
> the console and also when dumping the stack, the watchdog is touched.
> 
> This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu 
> just spins forever.

Hm, the flip side is that if a CPU is stuck spewing backtraces, we will now make all 
the other CPUs a lot more noisy - which might only 'lock up' because this CPU is 
stuck spewing oopses, right?

Andrew, what would be your preference?

Thanks,

	Ingo
