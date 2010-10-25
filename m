Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0JYWdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:33:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0JYWdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:33:45 -0400
Message-ID: <4CC60585.70503@zytor.com>
Date: Mon, 25 Oct 2010 15:32:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <20101019132236.GA19197@Krystal> <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6> <1287496495.16971.372.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <20101019212816.GA2855@redhat.com> <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6> <alpine.LFD.2.00.1010200015320.6815@localhost6.localdomain6> <1287538590.16971.548.camel@gandalf.stny.rr.com> <20101020015227.GA2011@redhat.com>
In-Reply-To: <20101020015227.GA2011@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 06:52 PM, Jason Baron wrote:
> 
> thanks Steve. I was about to say this. When CONFIG_CC_OPTIMIZE_FOR_SIZE
> is not set we don't get the double 'jmp' and the tracepoint code is
> moved out of line. It was mentioned that a number of distros ship with
> CONFIG_CC_OPTIMIZE_FOR_SIZE not set, and as Steve mentioned my original
> patch set was conditional on !CONFIG_CC_OPTIMIZE_FOR_SIZE.
> 
> using hot/cold labels gcc can fix the CONFIG_CC_OPTIMIZE_FOR_SIZE case,
> but its a non-trivial amount of work for gcc. I was hoping that if jump
> labels are included, we could make the gcc work happen.
> 

That's fair.  I think jump labels are still a win even in the
double-jump case (especially if the the tracepoint turns into a NOP
rather than a JMP.)

Code generated with -Os has a bunch of other problems, too.

	-hpa
