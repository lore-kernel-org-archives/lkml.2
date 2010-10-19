Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0JSNmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:42:12 -0400
Received: from www.tglx.de ([62.245.132.106]:54163 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0JSNmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:42:11 -0400
Date: Tue, 19 Oct 2010 15:41:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <20101019132236.GA19197@Krystal>
Message-ID: <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com> <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org> <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Mathieu Desnoyers wrote:

> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > With the addition of trace_softirq_raise() the softirq tracepoint got
> > even more convoluted. Why the tracepoints take two pointers to assign
> > an integer is beyond my comprehension.
> > 
> > But adding an extra case which treats the first pointer as an unsigned
> > long when the second pointer is NULL including the back and forth
> > type casting is just horrible.
> > 
> > Convert the softirq tracepoints to take a single unsigned int argument
> > for the softirq vector number and fix the call sites.
> 
> Well, there was originally a reason for this oddness. The in __do_softirq(),
> "h - softirq_ve"c computation was not needed outside of the tracepoint handler
> in the past, but it now seems to be required with the new inlined
> "kstat_incr_softirqs_this_cpu()".

Dudes, a vector computation is hardly a performance problem in that
function and definitely not an excuse for designing such horrible
interfaces.

Thanks,

	tglx
