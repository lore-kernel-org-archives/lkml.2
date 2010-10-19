Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0JSWSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:18:35 -0400
Received: from www.tglx.de ([62.245.132.106]:44050 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0JSWSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:18:34 -0400
Date: Wed, 20 Oct 2010 00:17:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Baron <jbaron@redhat.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
In-Reply-To: <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1010200015320.6815@localhost6.localdomain6>
References: <1287395077.29097.1543.camel@twins> <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com> <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6> <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
 <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <20101019212816.GA2855@redhat.com>
 <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Thomas Gleixner wrote:
> On Tue, 19 Oct 2010, Jason Baron wrote:
> > > Now even worse, when you NOP out the jmpq then your tracepoint is
> > > still not enabled. Brilliant !
> > > 
> > 
> > The 'jmpq' in the enabled case is patched with a jmpq to the body of the
> > tracepoint itself.
> 
> Brilliant.

IOW, We now jump around the jump which jumps around the disabled code.

Thanks,

	tglx

