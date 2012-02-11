Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273Ab2BKET4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 23:19:56 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49066 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab2BKETy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 23:19:54 -0500
Message-ID: <4F35EC3C.5090305@linux.vnet.ibm.com>
Date: Sat, 11 Feb 2012 09:49:08 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Sleep: Remove unnecessary label from suspend_freeze_processes()
References: <201202110035.32993.rjw@sisk.pl>
In-Reply-To: <201202110035.32993.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12021104-2674-0000-0000-0000034DE9AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 05:05 AM, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The Finish label in suspend_freeze_processes() is in fact necessary


s/necessary/unnecessary

> and makes the function look more complicated that it really is, so


s/that/than

> remove it (along with a few empty lines).
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> The patch is on top of linux-pm/pm-sleep.
> 
> Thanks,
> Rafael
> 
> ---
>  kernel/power/power.h |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> Index: linux/kernel/power/power.h
> ===================================================================
> --- linux.orig/kernel/power/power.h
> +++ linux/kernel/power/power.h
> @@ -234,16 +234,14 @@ static inline int suspend_freeze_process
>  	int error;
> 
>  	error = freeze_processes();
> -
>  	/*
>  	 * freeze_processes() automatically thaws every task if freezing
>  	 * fails. So we need not do anything extra upon error.
>  	 */
>  	if (error)
> -		goto Finish;
> +		return error;
> 
>  	error = freeze_kernel_threads();
> -
>  	/*
>  	 * freeze_kernel_threads() thaws only kernel threads upon freezing
>  	 * failure. So we have to thaw the userspace tasks ourselves.
> @@ -251,7 +249,6 @@ static inline int suspend_freeze_process
>  	if (error)
>  		thaw_processes();
> 
> - Finish:
>  	return error;
>  }
> 
> 

