Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab0DABnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:43:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:31445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab0DABns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,344,1267430400"; 
   d="scan'208";a="554011715"
Subject: Re: [patch] thermal: make lockdep happy
From: Zhang Rui <rui.zhang@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "casteyde.christian@free.fr" <casteyde.christian@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Frans Pop <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20100331170916.GA13784@bicker>
References: <20100331170916.GA13784@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 09:44:50 +0800
Message-ID: <1270086290.24064.4466.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 01:09 +0800, Dan Carpenter wrote:
> Hi Christian,
> 
> Can you test this patch?
> 
> I wrote this to address bugzilla bug:
> 	https://bugzilla.kernel.org/show_bug.cgi?id=15504
> 	BUG: key ffff88004c3811e0 not in .data! occured in lockdep.c
> 
> We now have to call sysfs_attr_init() for dynamically allocated sysfs 
> attributes or lockdep complains.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>

> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5066de5..d4fec47 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -725,6 +725,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  		goto release_idr;
>  
>  	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
> +	sysfs_attr_init(&dev->attr.attr);
>  	dev->attr.attr.name = dev->attr_name;
>  	dev->attr.attr.mode = 0444;
>  	dev->attr.show = thermal_cooling_device_trip_point_show;


