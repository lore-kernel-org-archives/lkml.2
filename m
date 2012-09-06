Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2IFPHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:07:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19979 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2IFPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:07:31 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dv6za2K3W50A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hUPM8fjf3YcA:10 a=_hZiHC8XfUJeMqtsrlEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346944049.1680.23.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 11:07:29 -0400
In-Reply-To: <1346943414.18408.31.camel@twins>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346943414.18408.31.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 16:56 +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > 
> > If a given CPU avoids the idle loop but also avoids starting a new
> > RCU grace period for a full minute, RCU can issue spurious RCU CPU
> > stall warnings.  This commit fixes this issue by adding a check for
> > ongoing grace period to avoid these spurious stall warnings. 
> 
> How would it avoid starting a new period for over a minute? fqs should
> happen, right? And holding rcu_read_lock() for over a minute surely is a
> bug.

I can see this happening in test cases, but it would seem weird on a
normal system. That is, for preempt rcu, having a process scheduled out
holding an rcu_read_lock() for over a minute could happen on a really
stressed out system. But for such a case, I don't think a warning is out
of question.

-- Steve


