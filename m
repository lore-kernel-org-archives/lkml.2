Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2EROnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:43:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4828 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2EROnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:43:06 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=pOYm6YVgi0cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GfgHd8XjqLkgNas_6n0A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337352183.6724.107.camel@gandalf.stny.rr.com>
Subject: Re: lockdep false positive in double_lock_balance()?
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Roland Dreier <roland@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 10:43:03 -0400
In-Reply-To: <1337282386.4281.77.camel@twins>
References: <1335314100-532-1-git-send-email-roland@kernel.org>
	 <alpine.LSU.2.00.1204251411460.4188@eggly.anvils>
	 <1337198420-5062-1-git-send-email-roland@kernel.org>
	 <1337282386.4281.77.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 21:19 +0200, Peter Zijlstra wrote:

> Something like this should fix it I think..
> 
> 
> ---
>  kernel/sched/rt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index c5565c3..b649108 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1556,7 +1556,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  				     task_running(rq, task) ||
>  				     !task->on_rq)) {
>  
> -				raw_spin_unlock(&lowest_rq->lock);
> +				double_unlock_balance(rq, lowest_rq);

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  				lowest_rq = NULL;
>  				break;
>  			}


