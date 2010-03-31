Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab0CaUMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:12:00 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:60373 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0CaUL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:11:58 -0400
From: Christian Casteyde <casteyde.christian@free.fr>
To: Dan Carpenter <error27@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] thermal: make lockdep happy
Date: Wed, 31 Mar 2010 22:17:32 +0200
User-Agent: KMail/1.9.10
References: <20100331170916.GA13784@bicker>
In-Reply-To: <20100331170916.GA13784@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003312217.33392.casteyde.christian@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to fix it, at least when applied on -rc3.
I'm updating the bugzilla entry.

Thanks.

Le mercredi 31 mars 2010, Dan Carpenter a écrit :
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
>
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5066de5..d4fec47 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -725,6 +725,7 @@ int thermal_zone_bind_cooling_device(struct
> thermal_zone_device *tz, goto release_idr;
>
>  	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
> +	sysfs_attr_init(&dev->attr.attr);
>  	dev->attr.attr.name = dev->attr_name;
>  	dev->attr.attr.mode = 0444;
>  	dev->attr.show = thermal_cooling_device_trip_point_show;


