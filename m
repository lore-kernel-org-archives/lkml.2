Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0JSW45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:56:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0JSW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:56:56 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=wGm5nfgfXM4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=S3LCjarNi3WNL6e033AA:9 a=yLvTSRubY_N9kOUKoGgA:7 a=dMH_MHFN8JUL1nYNAAjTgLtWKhoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <4CBE1F5E.8040807@zytor.com>
References: <4CBD79CF.2060706@jp.fujitsu.com>
	 <alpine.LFD.2.00.1010191428560.6815@localhost6.localdomain6>
	 <20101019132236.GA19197@Krystal>
	 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
	 <1287496495.16971.372.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
	 <20101019142820.GA14520@Krystal>
	 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
	 <20101019212816.GA2855@redhat.com>
	 <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
	 <20101019223842.GE2855@redhat.com>  <4CBE1F5E.8040807@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 18:56:53 -0400
Message-ID: <1287529013.16971.537.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:44 -0700, H. Peter Anvin wrote:
> On 10/19/2010 03:38 PM, Jason Baron wrote:
> > 
> > I'm not sure I did, the documentation says that we have nop followed by
> > a jmp:
> > 
> > +The new code is a 'nopl' followed by a 'jmp'. Thus:
> > +
> > +nopl - 0f 1f 44 00 00 - 5 bytes
> > +jmp  - eb 3e          - 2 bytes
> > 
> 
> There is no excuse for needing the second jump here, obviously...

Now the trick is to tell gcc that.

-- Steve


