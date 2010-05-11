Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0EKIyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 04:54:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33669 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0EKIyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 04:54:50 -0400
Date: Tue, 11 May 2010 03:54:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@vnet.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] INIT_SIGHAND: use SIG_DFL instead of NULL
Message-ID: <20100511085419.GB22688@us.ibm.com>
References: <4BE01C86.3050908@secunet.com>
 <20100509184510.GA15219@redhat.com>
 <4BE7B3BD.70901@secunet.com>
 <20100510194917.GA5249@redhat.com>
 <20100510195104.GE5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510195104.GE5249@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> Cosmetic, no changes in the compiled code. Just s/NULL/SIG_DFL/ to make
> it more readable and grep-friendly.
> 
> Note: probably SIG_IGN makes more sense, we could kill ignore_signals().
> But then kernel_init() should do flush_signal_handlers() before exec().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Serge E. Hallyn <serue@us.ibm.com>

> ---
> 
>  include/linux/init_task.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 34-rc1/include/linux/init_task.h~4_INIT_SIGHAND_USE_SIG_DFL	2010-05-10 20:26:08.000000000 +0200
> +++ 34-rc1/include/linux/init_task.h	2010-05-10 21:06:03.000000000 +0200
> @@ -43,7 +43,7 @@ extern struct nsproxy init_nsproxy;
> 
>  #define INIT_SIGHAND(sighand) {						\
>  	.count		= ATOMIC_INIT(1), 				\
> -	.action		= { { { .sa_handler = NULL, } }, },		\
> +	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
>  	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
>  	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
>  }
