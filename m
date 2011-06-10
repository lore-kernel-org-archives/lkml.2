Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1FJMeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:34:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1FJMeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:34:44 -0400
Date: Fri, 10 Jun 2011 14:34:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>,
        PaulMundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-ID: <20110610123416.GA12451@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.493181962@chello.nl>
 <20110609130617.f8aca966.akpm@linux-foundation.org>
 <20110609202707.GA28951@elte.hu>
 <1307652883.2497.1028.camel@laptop>
 <20110609140714.fc9ea187.akpm@linux-foundation.org>
 <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
 <1307705311.3941.118.camel@twins>
 <1307709030.3941.134.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307709030.3941.134.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> thinking that that would have my printk stmts appear on both the 
> fbcon as well as the serial line. But they fail to appear on the 
> latency tracer (current max was 165us waking an idle cpu).

Have you removed this bit:

                spin_unlock(&logbuf_lock);
                stop_critical_timings();        /* don't trace print latency */
                call_console_drivers(_con_start, _log_end);
                start_critical_timings();
                local_irq_restore(flags);

which hides the latencies from the latency tracer?

Thanks,

	Ingo
