Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab0JYWUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:20:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0JYWUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:20:42 -0400
Message-ID: <4CC60277.7050700@zytor.com>
Date: Mon, 25 Oct 2010 15:19:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
References: <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal> <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com> <20101020152745.GA7348@redhat.com> <4CC5FC99.8090203@zytor.com> <20101025220105.GB26517@Krystal> <4CC600DA.2000609@zytor.com>
In-Reply-To: <4CC600DA.2000609@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 03:12 PM, H. Peter Anvin wrote:
> 
> On 64 bits, use P6_NOP5; it seems to not suck on any platform.
> 
> On 32 bits, 3E 8D 74 26 00 (i.e. DS: + GENERIC_NOP4) seems to at least
> do okay.
> 
> I can't say these are the *best* (in fact, they are guaranteed not the
> best on some significant number of chips), but they haven't sucked on
> any chips I have been able to measure -- and are way faster than JMP.
> 

This is pure conjecture, I have not measured it, but I suspect in fact
that we could just change the composite nops in nops.h to use a 3E
prefix instead of a separate 90 nop.  Some platforms will take a penalty
on the prefix, but that would be balanced against handling two instructions.

The P5 core and others of the same generation might suffer, as it might
have been able to do U+V pipe pairing on two instructions which it
wouldn't for prefixes.

	-hpa

