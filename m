Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2IFNw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:52:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2IFNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:52:56 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eWVE56qDbh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Spn5lEgZA7UA:10 a=Toh7ie5Osn44MdnwavsA:9 a=PUjeQqilurYA:10 a=uVsdvZT7AKDWnRzl:21 a=OKnuBGmXxwH6cscD:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346939573.1680.18.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 07/23] rcu: Provide OOM handler to motivate
 lazy RCU callbacks
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
Date: Thu, 06 Sep 2012 09:52:53 -0400
In-Reply-To: <1346939197.18408.10.camel@twins>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346939197.18408.10.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 15:46 +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > +       get_online_cpus();
> > +       for_each_online_cpu(cpu)
> > +               for_each_rcu_flavor(rsp)
> > +                       smp_call_function_single(cpu, rcu_oom_notify_cpu,
> > +                                                rsp, 1);
> > +       put_online_cpus(); 
> 
> I guess blasting IPIs around is better than OOM but still.. do you
> really need to wait for each cpu individually, or would a construct
> using on_each_cpu() be possible, or better yet, on_each_cpu_cond()?

Also, what about having the rcu_oom_notify_cpu handler do the
for_each_rcu_flavor() and not send an IPI multiple times to a single
CPU?

-- Steve


