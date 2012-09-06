Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab2IFTtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:49:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2IFTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:49:13 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PxKtpm_zlhQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=tVGH1LJiL6wA:10 a=UPm3pfgAAAAA:8 a=717RbXmoKfpSo5214xIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=mOio7EKfaG4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346960950.1680.45.camel@gandalf.local.home>
Subject: Re: [PATCH] trace: Don't declare trace_*_rcuidle functions in
 modules
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 15:49:10 -0400
In-Reply-To: <20120905062306.GA14756@leaf>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20120831180052.GB4259@jtriplet-mobl1>
	 <20120904223350.GQ2593@linux.vnet.ibm.com>
	 <1346799082.27919.31.camel@gandalf.local.home>
	 <20120904230834.GB11494@jtriplet-mobl1>
	 <1346801031.27919.39.camel@gandalf.local.home>
	 <20120904233344.GB11855@jtriplet-mobl1>
	 <1346802402.27919.44.camel@gandalf.local.home>
	 <20120905062306.GA14756@leaf>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 23:23 -0700, Josh Triplett wrote:
> Tracepoints declare a static inline trace_*_rcuidle variant of the trace
> function, to support safely generating trace events from the idle loop.
> Module code never actually uses that variant of trace functions, because
> modules don't run code that needs tracing with RCU idled.  However, the
> declaration of those otherwise unused functions causes the module to
> reference rcu_idle_exit and rcu_idle_enter, which RCU does not export to
> modules.
> 
> To avoid this, don't generate trace_*_rcuidle functions for tracepoints
> declared in module code.
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


