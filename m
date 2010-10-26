Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0JZAjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:39:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0JZAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:39:52 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oGMlB6cnAAAA:8 a=n8Tcsx63QFR4-MFgzv0A:9 a=YujvksMxnD3JDJyzZXgA:7 a=69TuUpX0ot7YXqv4o06bxPeQoZUA:4 a=PUjeQqilurYA:10 a=CY6gl2JlH4YA:10 a=kD5PlOjZSZ_WhJZb:21 a=4h8_FdLL_7NgKifS:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
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
In-Reply-To: <20101025225507.GA14561@Krystal>
References: <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6>
	 <1287523439.16971.433.camel@gandalf.stny.rr.com>
	 <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal>
	 <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com>
	 <20101020152745.GA7348@redhat.com> <4CC5FC99.8090203@zytor.com>
	 <20101025220105.GB26517@Krystal> <4CC600DA.2000609@zytor.com>
	 <20101025225507.GA14561@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Oct 2010 20:39:48 -0400
Message-ID: <1288053588.18238.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 18:55 -0400, Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
> > On 10/25/2010 03:01 PM, Mathieu Desnoyers wrote:
> > > * H. Peter Anvin (hpa@zytor.com) wrote:
> > >> On 10/20/2010 08:27 AM, Jason Baron wrote:
> > >>>
> > >>> sure. The idea of the 'jmp 0' was simply to be an lcd for x86, if
> > >>> there's a better lcd for x86, I'll update it. But note, that since the
> > >>> 'jmp 0' is patched to a better nop at boot, we wouldn't see much gain.
> > >>> And in the boot path we are using 'text_poke_early()', so avoiding that
> > >>> isn't going to improve things much.
> > >>>
> > >>
> > >> It's still a completely unnecessary waste of startup time some
> > >> potentially significant fraction of the time.  Startup time matters,
> > >> especially as the number of tracepoints grow.
> > > 
> > > We're still waiting for input for the best single-5-byte-instruction nop that
> > > will work on all x86 variants. Please note that the GENERIC_NOP5 is actually two
> > > instructions one next to each other, which is not appropriate here.
> > > 
> > 
> > On 64 bits, use P6_NOP5; it seems to not suck on any platform.
> > 
> > On 32 bits, 3E 8D 74 26 00 (i.e. DS: + GENERIC_NOP4) seems to at least
> > do okay.
> > 
> > I can't say these are the *best* (in fact, they are guaranteed not the
> > best on some significant number of chips), but they haven't sucked on
> > any chips I have been able to measure -- and are way faster than JMP.
> 
> Cool, thanks for the info! Steven and Jason should probably update their
> respective infrastructure to use the 32-bit 5-byte nop you propose rather than
> the 5-byte jump.

Actually, I was thinking that we could take any 5 byte nop. The
alternate code is executed _before_ SMP is enabled. Thus we should not
have any cases where something could be executing in midstream.

-- Steve


