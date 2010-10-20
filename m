Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0JTBgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:36:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47985 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0JTBge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:36:34 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=AgHnIR4j_F4qsib0P84A:9 a=iI4kYmX-14UxCD_J_n85NKNP9n0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
In-Reply-To: <alpine.LFD.2.00.1010200015320.6815@localhost6.localdomain6>
References: <1287395077.29097.1543.camel@twins>
	 <1287398936.29097.1548.camel@twins> <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
	 <20101019212816.GA2855@redhat.com>
	 <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
	 <alpine.LFD.2.00.1010200015320.6815@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 21:36:30 -0400
Message-ID: <1287538590.16971.548.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 00:17 +0200, Thomas Gleixner wrote:
> On Tue, 19 Oct 2010, Thomas Gleixner wrote:
> > On Tue, 19 Oct 2010, Jason Baron wrote:
> > > > Now even worse, when you NOP out the jmpq then your tracepoint is
> > > > still not enabled. Brilliant !
> > > > 
> > > 
> > > The 'jmpq' in the enabled case is patched with a jmpq to the body of the
> > > tracepoint itself.
> > 
> > Brilliant.
> 
> IOW, We now jump around the jump which jumps around the disabled code.
> 


Do you happen to have CONFIG_CC_OPTIMIZE_FOR_SIZE set? If so, then this
is a known issue. We even originally had jump label enabled _only_ if
CC_OPTIMIZE_FOR_SIZE was not set, but hpa NAK'd it.

http://lkml.org/lkml/2010/9/22/482

http://lkml.org/lkml/2010/9/20/488

http://lkml.org/lkml/2010/9/24/259

-- Steve


