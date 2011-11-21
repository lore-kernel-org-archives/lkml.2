Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1KUMyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:54:13 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35850 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1KUMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:54:12 -0500
Message-ID: <4ECA49EF.4000400@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 18:24:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / Sleep: Remove unnecessary label and jumps to it
 form PM core code
References: <201111192254.39049.rjw@sisk.pl>
In-Reply-To: <201111192254.39049.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112102-5140-0000-0000-0000004A30E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 03:24 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The "End" label in device_prepare() in drivers/base/power/main.c is
> not necessary and the jumps to it have no real effect, so remove them
> all.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

> ---
>  drivers/base/power/main.c |    7 -------
>  1 file changed, 7 deletions(-)
> 
> Index: linux/drivers/base/power/main.c
> ===================================================================
> --- linux.orig/drivers/base/power/main.c
> +++ linux/drivers/base/power/main.c
> @@ -1033,22 +1033,16 @@ static int device_prepare(struct device
>  		if (dev->pm_domain->ops.prepare)
>  			error = dev->pm_domain->ops.prepare(dev);
>  		suspend_report_result(dev->pm_domain->ops.prepare, error);
> -		if (error)
> -			goto End;
>  	} else if (dev->type && dev->type->pm) {
>  		pm_dev_dbg(dev, state, "preparing type ");
>  		if (dev->type->pm->prepare)
>  			error = dev->type->pm->prepare(dev);
>  		suspend_report_result(dev->type->pm->prepare, error);
> -		if (error)
> -			goto End;
>  	} else if (dev->class && dev->class->pm) {
>  		pm_dev_dbg(dev, state, "preparing class ");
>  		if (dev->class->pm->prepare)
>  			error = dev->class->pm->prepare(dev);
>  		suspend_report_result(dev->class->pm->prepare, error);
> -		if (error)
> -			goto End;
>  	} else if (dev->bus && dev->bus->pm) {
>  		pm_dev_dbg(dev, state, "preparing ");
>  		if (dev->bus->pm->prepare)
> @@ -1056,7 +1050,6 @@ static int device_prepare(struct device
>  		suspend_report_result(dev->bus->pm->prepare, error);
>  	}
> 
> - End:
>  	device_unlock(dev);
> 
>  	return error;

