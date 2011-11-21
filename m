Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1KUMrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:47:25 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54429 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1KUMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:47:22 -0500
Message-ID: <4ECA484F.5000107@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 18:17:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Sleep: Simplify device_suspend_noirq()
References: <201111192343.03677.rjw@sisk.pl>
In-Reply-To: <201111192343.03677.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112112-8256-0000-0000-0000003AA47B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 04:13 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove a few if () and return statements in device_suspend_noirq()
> that aren't really necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

> ---
>  drivers/base/power/main.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> Index: linux/drivers/base/power/main.c
> ===================================================================
> --- linux.orig/drivers/base/power/main.c
> +++ linux/drivers/base/power/main.c
> @@ -763,31 +763,23 @@ static pm_message_t resume_event(pm_mess
>   */
>  static int device_suspend_noirq(struct device *dev, pm_message_t state)
>  {
> -	int error;
> +	int error = 0;
> 
>  	if (dev->pm_domain) {
>  		pm_dev_dbg(dev, state, "LATE power domain ");
>  		error = pm_noirq_op(dev, &dev->pm_domain->ops, state);
> -		if (error)
> -			return error;
>  	} else if (dev->type && dev->type->pm) {
>  		pm_dev_dbg(dev, state, "LATE type ");
>  		error = pm_noirq_op(dev, dev->type->pm, state);
> -		if (error)
> -			return error;
>  	} else if (dev->class && dev->class->pm) {
>  		pm_dev_dbg(dev, state, "LATE class ");
>  		error = pm_noirq_op(dev, dev->class->pm, state);
> -		if (error)
> -			return error;
>  	} else if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "LATE ");
>  		error = pm_noirq_op(dev, dev->bus->pm, state);
> -		if (error)
> -			return error;
>  	}
> 
> -	return 0;
> +	return error;
>  }
> 
>  /**

