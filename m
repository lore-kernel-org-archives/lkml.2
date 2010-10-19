Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab0JSOqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:46:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0JSOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:46:42 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cv9M0Kd9k6JBHmPa_70A:9 a=6AFaqLeHzO7qKCIOQTWM4erqBsgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
In-Reply-To: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
References: <4C724298.4050509@jp.fujitsu.com>
	 <tip-2bf2160d8805de64308e2e7c3cd97813cb58ed2f@git.kernel.org>
	 <20100908112529.GA25931@elte.hu> <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 10:46:39 -0400
Message-ID: <1287499599.16971.380.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 16:07 +0200, Thomas Gleixner wrote:

> The vector computation is compared to the extra tracing induced jumps
> probably not even measurable. Stop defending horrible coding with
> handwavy performance and impact arguments.

Yes this was crappy code, I'm not defending it. But this code was from
the original tracepoints. I just looked at when this code was added, and
it was still in the time TRACE_EVENT() was in a major flux. Heck, the
code resided in include/trace/irq.h and not include/trace/events/irq.h.
And yes, a lot of decisions back then were put on handwaving performance
and impact, and it was not just coming from us.

I admit I should have cleaned it up, but I did not want to touch it
until it actually broke ;-)

-- Steve


