Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2EOM1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:27:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2EOM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:27:38 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: panto@antoniou-consulting.com, smuckle@quicinc.com,
        Juri Lelli <juri.lelli@gmail.com>, mingo@elte.hu,
        linaro-sched-sig@lists.linaro.org, rostedt@goodmis.org,
        tglx@linutronix.de, geoff@infradead.org, efault@gmx.de,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1337084609.27020.156.camel@laptop>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 14:27:25 +0200
Message-ID: <1337084845.27020.157.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 14:23 +0200, Peter Zijlstra wrote:
> -#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
>  static inline int find_new_ilb(int call_cpu)
>  {
>         return nr_cpu_ids;
>  }
> -#endif 

That was missing a hunk...

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4524,6 +4524,11 @@ static struct {
 
 static inline int find_new_ilb(int call_cpu)
 {
+       int ilb = cpumask_first(nohz.idle_cpus_mask);
+
+       if (ilb < nr_cpu_ids && idle_cpu(ilb))
+               return ilb;
+
        return nr_cpu_ids;
 }


