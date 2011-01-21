Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1AUOFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:05:33 -0500
Received: from www.tglx.de ([62.245.132.106]:37027 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1AUOFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:05:32 -0500
Date: Fri, 21 Jan 2011 15:05:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hillf Danton <dhillf@gmail.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: x86_64: could increment fp when getting wchan?
In-Reply-To: <AANLkTi=kcpiXAFAy9c31qU+4u=BHckSec29C5Khm3gxC@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101211501180.2971@localhost6.localdomain6>
References: <AANLkTi=kcpiXAFAy9c31qU+4u=BHckSec29C5Khm3gxC@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Hillf Danton wrote:

> When getting wchan (wait channel?) the stack of given task is scanned
> for IP that is not in the scheduling area. What looks odd is the IP
> could be checked as many times as allowed in the loop without changing
> the location on stack. Could the IP be checked up stair the stack?

Errm.
 
> Hillf
> ---
> 
> --- a/arch/x86/kernel/process_64.c	2011-01-05 08:50:20.000000000 +0800
> +++ b/arch/x86/kernel/process_64.c	2011-01-21 21:46:04.000000000 +0800
> @@ -543,7 +543,7 @@ unsigned long get_wchan(struct task_stru
>  		ip = *(u64 *)(fp+8);

IP (Return address) is read from stack via fp (Frame pointer)

>  		if (!in_sched_functions(ip))
>  			return ip;
> -		fp = *(u64 *)fp;

Now fp is set to the next stack frame, so the next loop will read a
different IP.

> +		fp += 8;
>  	} while (count++ < 16);
>  	return 0;
>  }

Thanks,

	tglx

