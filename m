Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LVIak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 03:30:40 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:49680 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LVIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 03:30:39 -0500
Date: Wed, 22 Dec 2010 09:30:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
Subject: Re: [PATCH 2/5] Add nsecs_to_cputime64 interface for asm-generic
 -v2
Message-ID: <20101222093032.0320c9bf@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1292980144-28796-3-git-send-email-venki@google.com>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	<1292980144-28796-3-git-send-email-venki@google.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Dec 2010 17:09:01 -0800
Venkatesh Pallipadi <venki@google.com> wrote:

> Add nsecs_to_cputime64 interface. This is used in following patches that
> updates cpu irq stat based on ns granularity info in IRQ_TIME_ACCOUNTING.
> 
> Tested-by: Shaun Ruffell <sruffell@digium.com>
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  include/asm-generic/cputime.h |    3 +++
>  include/linux/jiffies.h       |    1 +
>  kernel/time.c                 |   23 +++++++++++++++++++++--
>  3 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
> index 2bcc5c7..61e03dd 100644
> --- a/include/asm-generic/cputime.h
> +++ b/include/asm-generic/cputime.h
> @@ -30,6 +30,9 @@ typedef u64 cputime64_t;
>  #define cputime64_to_jiffies64(__ct)	(__ct)
>  #define jiffies64_to_cputime64(__jif)	(__jif)
>  #define cputime_to_cputime64(__ct)	((u64) __ct)
> +#define cputime64_gt(__a, __b)		((__a) >  (__b))
> +
> +#define nsecs_to_cputime64(__ct)	nsecs_to_jiffies64(__ct)
> 
> 
>  /*

If you define a new cputime primitive it is not enough to add it to the
generic cputime header. You have to add it to the arch-specific cputime
header for ia64, powerpc and s390 as well. Otherwise the build will
break with CONFIG_VIRT_CPU_ACCOUNTING=y on these architectures once the
new primitive is used.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

