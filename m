Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab1LJO7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:59:15 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43573 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751719Ab1LJO7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:59:13 -0500
Date: Sat, 10 Dec 2011 09:59:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/4] PM: Run the driver callback directly if the subsystem
 one is not there
In-Reply-To: <201112100020.58055.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1112100958350.594-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Dec 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the PM core execute driver PM callbacks directly if the
> corresponding subsystem callbacks are not present.
> --- linux.orig/drivers/base/power/runtime.c
> +++ linux/drivers/base/power/runtime.c
> @@ -250,6 +250,9 @@ static int rpm_idle(struct device *dev,
>  	else
>  		callback = NULL;
>  
> +	if (!callback && dev->driver && dev->driver->pm)
> +		callback = dev->driver->pm->runtime_idle;
> +
>  	if (callback)
>  		__rpm_callback(callback, dev);
>  
> @@ -713,6 +716,12 @@ static int rpm_resume(struct device *dev
>  	else
>  		callback = NULL;
>  
> +	if (!callback && dev->driver && dev->driver->pm)
> +		callback = dev->driver->pm->runtime_suspend;
> +
> +	if (!callback && dev->driver && dev->driver->pm)
> +		callback = dev->driver->pm->runtime_resume;
> +
>  	retval = rpm_callback(callback, dev);
>  	if (retval) {
>  		__update_runtime_status(dev, RPM_SUSPENDED);

Looks like part of that got added in the wrong place.

Alan Stern

