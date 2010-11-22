Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0KVMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:46:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42317 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0KVMq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:46:28 -0500
Subject: Re: [PATCH] generic-ipi: add lock context annotations
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
References: <1290411232-11439-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 13:46:43 +0100
Message-ID: <1290430003.2072.101.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 16:33 +0900, Namhyung Kim wrote:
> The ipi_call_[un]lock[_irq] functions grab/release a spin lock
> but were missing proper annotations. Add it.

I really have to ask why bother? Why not add some smarts to whatever
uses these annotations?

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/smp.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 12ed8b0..5a62f1f 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -511,21 +511,25 @@ int smp_call_function(smp_call_func_t func, void *info, int wait)
>  EXPORT_SYMBOL(smp_call_function);
>  
>  void ipi_call_lock(void)
> +	__acquires(call_function.lock)
>  {
>  	raw_spin_lock(&call_function.lock);
>  }
>  
>  void ipi_call_unlock(void)
> +	__releases(call_function.lock)
>  {
>  	raw_spin_unlock(&call_function.lock);
>  }
>  
>  void ipi_call_lock_irq(void)
> +	__acquires(call_function.lock)
>  {
>  	raw_spin_lock_irq(&call_function.lock);
>  }
>  
>  void ipi_call_unlock_irq(void)
> +	__releases(call_function.lock)
>  {
>  	raw_spin_unlock_irq(&call_function.lock);
>  }


