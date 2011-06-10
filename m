Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab1FJOw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:52:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab1FJOwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:52:25 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=nbpwko1cA38A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3o_o_88ZBFY3iYaRDfIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: BUG on 3.0-rc on commit
 d72bce0e67e8afc6eb959f656013cbb577426f1e
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: habanero@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1307717156.3941.169.camel@twins>
References: <1307711837.23688.33.camel@atheurer-ubuntu10>
	 <1307715084.3941.166.camel@twins>  <1307717156.3941.169.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Jun 2011 10:52:22 -0400
Message-ID: <1307717542.9218.43.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 16:45 +0200, Peter Zijlstra wrote:

> > > 
> > > This is on a Westmere-EX (4 socket, 40 cores)
> > 
> > Hmm, how often does that happen? my wsm-ep (2*6*2) doesn't seem to
> > suffer said problem. I'll try and see if I can spot the boo-boo. Also,
> > happen to have a .config handy?
> 
> Does the below cure things?
> 
> ---
>  kernel/Makefile |    1 +
>  kernel/sched.c  |   39 +++++++++++++++++++++++----------------
>  2 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2d64cfc..65eff6c 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
> +obj-m += test.o

Did you mean to keep this?

-- Steve

>  obj-$(CONFIG_TREE_RCU) += rcutree.o
>  obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
>  obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o


