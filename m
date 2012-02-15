Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab2BOE7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:59:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51206 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2BOE7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:59:11 -0500
Message-ID: <1329281947.2555.26.camel@edumazet-laptop>
Subject: Re: [PATCH v1] percpu: use raw_local_irq_* in _this_cpu op
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Date: Wed, 15 Feb 2012 05:59:07 +0100
In-Reply-To: <1329280586-6878-1-git-send-email-tom.leiming@gmail.com>
References: <1329280586-6878-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 12:36 +0800, Ming Lei a écrit :
> It doesn't make sense to trace irq off or do irq flags
> lock proving inside 'this_cpu' operations, so replace local_irq_*
> with raw_local_irq_* in 'this_cpu' op.
...
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  include/linux/percpu.h |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index 6e68d05..5ed1e38 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -294,9 +294,9 @@ do {									\
>  #define _this_cpu_generic_to_op(pcp, val, op)				\
>  do {									\
>  	unsigned long flags;						\
> -	local_irq_save(flags);						\
> +	raw_local_irq_save(flags);						\
>  	*__this_cpu_ptr(&(pcp)) op val;					\
> -	local_irq_restore(flags);					\
> +	raw_local_irq_restore(flags);					\
>  } while (0)
>  

Could you check the alignement of trailing '\' ?




