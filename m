Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab0LCWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:04:48 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752527Ab0LCWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:04:47 -0500
Date: Fri, 3 Dec 2010 17:04:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PM: Use pm_wakeup_pending() in device_suspend()
In-Reply-To: <201012032254.55542.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1012031702490.1682-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Rafael J. Wysocki wrote:

> The devices will be suspended and the suspend will progress until it's
> finally aborted before putting the system into the sleep state.  But I agree
> it's better to check pm_wakeup_pending() in async_suspend() too,
> so I think we can simply put it into __device_suspend() instead, like in the
> patch below.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Use pm_wakeup_pending() in __device_suspend()
> 
> Before starting to suspend a device in __device_suspend() check if
> there's a request to abort the power transition and return -EBUSY
> in that case.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -877,6 +877,11 @@ static int __device_suspend(struct devic
>  	if (async_error)
>  		goto End;
>  
> +	if (pm_wakeup_pending()) {
> +		async_error = -EBUSY;
> +		goto End;
> +	}
> +
>  	if (dev->class) {
>  		if (dev->class->pm) {
>  			pm_dev_dbg(dev, state, "class ");
> 

Looks good.

Alan Stern

