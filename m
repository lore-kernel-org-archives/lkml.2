Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2JPFcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:32:12 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50386 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2JPFcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:32:11 -0400
Message-ID: <507CF124.4000500@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 11:01:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cernekee@gmail.com, torbenh@gmx.de,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] Fix scheduling-while-atomic problem in console_cpu_notify()
References: <20121016003128.GA5879@linux.vnet.ibm.com> <20121016043559.GA32179@linux.vnet.ibm.com>
In-Reply-To: <20121016043559.GA32179@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101605-0260-0000-0000-000001FD3A83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 10:05 AM, Paul E. McKenney wrote:
> On Mon, Oct 15, 2012 at 05:31:28PM -0700, Paul E. McKenney wrote:
>> The console_cpu_notify( function runs with interrupts disabled in
>> the CPU_DEAD case.  It therefore cannot block, for example, as will
>> happen when it calls console_lock().  Therefore, remove the CPU_DEAD
>> leg of the switch statement to avoid this problem.
>>
>> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> s/CPU_DEAD/CPU_DYING/
> 
> Apparently it is a bad idea to compose and send a patch while in a
> C++ standards committee meeting where people are arguing about async
> futures...  Fixed patch below.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> printk: Fix scheduling-while-atomic problem in console_cpu_notify()
> 
> The console_cpu_notify( function runs with interrupts disabled in
> the CPU_DYING case.  It therefore cannot block, for example, as will
> happen when it calls console_lock().  Therefore, remove the CPU_DYING
> leg of the switch statement to avoid this problem.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> diff --git a/kernel/printk.c b/kernel/printk.c
> index 66a2ea3..2d607f4 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1890,7 +1890,6 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
>  	switch (action) {
>  	case CPU_ONLINE:
>  	case CPU_DEAD:
> -	case CPU_DYING:
>  	case CPU_DOWN_FAILED:
>  	case CPU_UP_CANCELED:
>  		console_lock();
> 


