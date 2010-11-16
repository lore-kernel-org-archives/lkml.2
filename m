Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0KPQn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:43:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:58624 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab0KPQnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:43:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,206,1288594800"; 
   d="scan'208";a="574347989"
Message-ID: <4CE2B4AC.5080606@linux.intel.com>
Date: Tue, 16 Nov 2010 08:43:24 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergio Aguirre <saaguirre@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC][PATCH] futex: Hide false positive about uninit var usage
References: <1289925157-17054-1-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289925157-17054-1-git-send-email-saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 08:32 AM, Sergio Aguirre wrote:
> In exit_robust_list, there was this warning shown:
>
> kernel/futex.c: In function 'exit_robust_list':
> kernel/futex.c:2492: warning: 'next_pi' may be used uninitialized in this function
>
> Which is a false positive, since in the function, the only scenario
> possible in which the var is read, is after a successful excecution of
> fetch_robust_entry, which populates the variable.
>
> So there's no real possibility of it being used uninitialized.

Hi Sergio,

You are correct. Thomas has recently pulled my fix for this into tip, it 
should be queued for mainline already.

Thanks,

Darren Hart

>
> Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Darren Hart<dvhart@linux.intel.com>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Namhyung Kim<namhyung@gmail.com>
> ---
>   kernel/futex.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..3646157 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2489,7 +2489,8 @@ void exit_robust_list(struct task_struct *curr)
>   {
>   	struct robust_list_head __user *head = curr->robust_list;
>   	struct robust_list __user *entry, *next_entry, *pending;
> -	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
> +	unsigned int limit = ROBUST_LIST_LIMIT, pi;
> +	unsigned int uninitialized_var(next_pi), pip;
>   	unsigned long futex_offset;
>   	int rc;
>


-- 
Darren Hart
Yocto Linux Kernel
