Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2CEVr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:47:59 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35024 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2CEVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:47:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.224.9 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 13:47:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120305214747.GA9425@kroah.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 08:47:41AM -0700, Grant Likely wrote:
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -587,6 +587,10 @@ struct device_dma_parameters {
>   * @mutex:	Mutex to synchronize calls to its driver.
>   * @bus:	Type of bus device is on.
>   * @driver:	Which driver has allocated this
> + * @deferred_probe: entry in deferred_probe_list which is used to retry the
> + * 		binding of drivers which were unable to get all the resources
> + * 		needed by the device; typically because it depends on another
> + * 		driver getting probed first.
>   * @platform_data: Platform data specific to the device.
>   * 		Example: For devices on custom boards, as typical of embedded
>   * 		and SOC based hardware, Linux often uses platform_data to point
> @@ -646,6 +650,7 @@ struct device {
>  	struct bus_type	*bus;		/* type of bus device is on */
>  	struct device_driver *driver;	/* which driver has allocated this
>  					   device */
> +	struct list_head	deferred_probe;
>  	void		*platform_data;	/* Platform specific data, device
>  					   core doesn't touch it */
>  	struct dev_pm_info	power;

This can go into the "struct device_private" structure instead, right?
That would be better to ensure that no non-driver-core code ever touches
this thing.

thanks,

greg k-h
