Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250Ab2KBNnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:43:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13096 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2KBNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:43:35 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=uwsahkhRy6MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5gZtQp4jYqcA:10 a=pGLkceISAAAA:8 a=c_KQlyFGZ-cgMrcE2nMA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351863814.4004.126.camel@gandalf.local.home>
Subject: Re: [PATCH] IRQ CORE: irq_work_queue function return value not used.
From: Steven Rostedt <rostedt@goodmis.org>
To: anish kumar <anish198519851985@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
Date: Fri, 02 Nov 2012 09:43:34 -0400
In-Reply-To: <1351862676-5426-1-git-send-email-anish198519851985@gmail.com>
References: <1351862676-5426-1-git-send-email-anish198519851985@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 22:24 +0900, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> As no one is using the return value of irq_work_queue function
> it is better to just make it void.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Peter, like to take this patch? Or is there a reason you have for
irq_work_queue() returning a value?

-- Steve

> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  kernel/irq_work.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 1588e3b..a85c4b3 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -79,17 +79,17 @@ static void __irq_work_queue(struct irq_work *work)
>   *
>   * Can be re-enqueued while the callback is still in progress.
>   */
> -bool irq_work_queue(struct irq_work *work)
> +void irq_work_queue(struct irq_work *work)
>  {
>  	if (!irq_work_claim(work)) {
>  		/*
>  		 * Already enqueued, can't do!
>  		 */
> -		return false;
> +		return;
>  	}
>  
>  	__irq_work_queue(work);
> -	return true;
> +	return;
>  }
>  EXPORT_SYMBOL_GPL(irq_work_queue);
>  


