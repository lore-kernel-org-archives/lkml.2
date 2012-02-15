Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2BOTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:16:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9192 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BOTQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:16:24 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=JW920i4TZMwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8 a=H09E7gtIAA9GHUcujMgA:9 a=hPmmItWqbasD5vG-fjsA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to
 handle rcu_idle_exit() tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20120214180947.GA30057@smp.if.uj.edu.pl>
References: <20120214180947.GA30057@smp.if.uj.edu.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 14:16:19 -0500
Message-ID: <1329333379.10311.3.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 19:09 +0100, Witold Baryluk wrote:
> Hi,
> 
> I have some problem with cpuidle tracing:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=42742
> 
> so I applied 3 patches from https://lkml.org/lkml/headers/2012/2/7/231
> 
> > Steven Rostedt (3):
> >      tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections
> >      x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
> >      cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() section
> 
> All 3 patches applied cleanly but for unknown reasons to me compilation fails:

Yeah, my testing hit this issue and I fixed it up. I pushed out my
patches to Ingo that have passed all my tests. You can get them here:

https://lkml.org/lkml/2012/2/13/528

You only need to apply patches 3,4 and 5.

-- Steve

> 
> CC      arch/x86/kernel/process.o
>   arch/x86/kernel/process.c: In function ‘default_idle’:
>   arch/x86/kernel/process.c:380:3: error: implicit declaration of function ‘trace_power_start_rcuidle’ [-Werror=implicit-function-declaration]
>   arch/x86/kernel/process.c:394:3: error: implicit declaration of function ‘trace_power_end_rcuidle’ [-Werror=implicit-function-declaration]
>   cc1: some warnings being treated as errors
> 


