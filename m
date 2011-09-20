Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab1ITRIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:08:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1ITRIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:08:38 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=H2PQwMZWR0Lr_k2jd2MA:9 a=Sjy0n-h3gGt9TFKUvWsA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <alpine.LFD.2.02.1109201806220.2723@ionos>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
	 <alpine.LFD.2.02.1109201334590.2723@ionos>
	 <alpine.DEB.2.00.1109200947100.8056@router.home>
	 <alpine.LFD.2.02.1109201703560.2723@ionos>
	 <alpine.DEB.2.00.1109201059590.8056@router.home>
	 <alpine.LFD.2.02.1109201806220.2723@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 13:08:36 -0400
Message-ID: <1316538516.29966.103.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 18:51 +0200, Thomas Gleixner wrote:

> this_cpu_*() is patently wrong. It should be: random_cpu_*() or
> any_cpu_*(). This way you could have avoided confusion in the first
> place and made it entirely clear what the interfaces are about.

Thinking about this, my vote is for "any_cpu_*()". I initially liked my
own snapshot_cpu_*(), and even random_cpu_*() is humorous. But truly,
the "any_cpu_*()" has the best meaning. As you really don't seem to care
about which CPU you access. Sure you can document something like:

/*
 * Will modify the per cpu data on the current CPU, but there is no
 * guarantee which CPU you may be on, as you can migrate just before
 * or after calling this function. Only the scope of this function
 * will be atomic to the CPU the task is currently on, but no guarantee
 * before or after the function. If you care about that, disable
 * preemption and use the this_cpu_*() variants.
 */

-- Steve


