Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0JYWzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:55:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48384 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752695Ab0JYWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:55:09 -0400
Date: Mon, 25 Oct 2010 18:55:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20101025225507.GA14561@Krystal>
References: <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal> <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com> <20101020152745.GA7348@redhat.com> <4CC5FC99.8090203@zytor.com> <20101025220105.GB26517@Krystal> <4CC600DA.2000609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC600DA.2000609@zytor.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:54:03 up 33 days,  2:56,  3 users,  load average: 0.18, 0.11,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 10/25/2010 03:01 PM, Mathieu Desnoyers wrote:
> > * H. Peter Anvin (hpa@zytor.com) wrote:
> >> On 10/20/2010 08:27 AM, Jason Baron wrote:
> >>>
> >>> sure. The idea of the 'jmp 0' was simply to be an lcd for x86, if
> >>> there's a better lcd for x86, I'll update it. But note, that since the
> >>> 'jmp 0' is patched to a better nop at boot, we wouldn't see much gain.
> >>> And in the boot path we are using 'text_poke_early()', so avoiding that
> >>> isn't going to improve things much.
> >>>
> >>
> >> It's still a completely unnecessary waste of startup time some
> >> potentially significant fraction of the time.  Startup time matters,
> >> especially as the number of tracepoints grow.
> > 
> > We're still waiting for input for the best single-5-byte-instruction nop that
> > will work on all x86 variants. Please note that the GENERIC_NOP5 is actually two
> > instructions one next to each other, which is not appropriate here.
> > 
> 
> On 64 bits, use P6_NOP5; it seems to not suck on any platform.
> 
> On 32 bits, 3E 8D 74 26 00 (i.e. DS: + GENERIC_NOP4) seems to at least
> do okay.
> 
> I can't say these are the *best* (in fact, they are guaranteed not the
> best on some significant number of chips), but they haven't sucked on
> any chips I have been able to measure -- and are way faster than JMP.

Cool, thanks for the info! Steven and Jason should probably update their
respective infrastructure to use the 32-bit 5-byte nop you propose rather than
the 5-byte jump.

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
