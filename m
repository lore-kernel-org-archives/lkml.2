Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1HRIuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:50:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab1HRIuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:50:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] thermal: Rename generate_netlink_event
Date: Thu, 18 Aug 2011 10:51:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, "R.Durgadoss" <durgadoss.r@intel.com>,
        Len Brown <len.brown@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110818094944.3ce83401@endymion.delvare>
In-Reply-To: <20110818094944.3ce83401@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181051.51492.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 18, 2011, Jean Delvare wrote:
> It doesn't seem right for the thermal subsystem to export a symbol
> named generate_netlink_event. This function is thermal-specific and
> its name should reflect that fact. Rename it to
> thermal_generate_netlink_event.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: R.Durgadoss <durgadoss.r@intel.com>
> Cc: Len Brown <len.brown@intel.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  Documentation/thermal/sysfs-api.txt |    2 +-
>  drivers/thermal/thermal_sys.c       |    4 ++--
>  include/linux/thermal.h             |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- linux-3.1-rc2.orig/Documentation/thermal/sysfs-api.txt	2011-07-22 04:17:23.000000000 +0200
> +++ linux-3.1-rc2/Documentation/thermal/sysfs-api.txt	2011-08-17 22:36:57.000000000 +0200
> @@ -284,7 +284,7 @@ method, the sys I/F structure will be bu
>  The framework includes a simple notification mechanism, in the form of a
>  netlink event. Netlink socket initialization is done during the _init_
>  of the framework. Drivers which intend to use the notification mechanism
> -just need to call generate_netlink_event() with two arguments viz
> +just need to call thermal_generate_netlink_event() with two arguments viz
>  (originator, event). Typically the originator will be an integer assigned
>  to a thermal_zone_device when it registers itself with the framework. The
>  event will be one of:{THERMAL_AUX0, THERMAL_AUX1, THERMAL_CRITICAL,
> --- linux-3.1-rc2.orig/drivers/thermal/thermal_sys.c	2011-08-16 11:49:57.000000000 +0200
> +++ linux-3.1-rc2/drivers/thermal/thermal_sys.c	2011-08-17 22:37:22.000000000 +0200
> @@ -1304,7 +1304,7 @@ static struct genl_multicast_group therm
>  	.name = THERMAL_GENL_MCAST_GROUP_NAME,
>  };
>  
> -int generate_netlink_event(u32 orig, enum events event)
> +int thermal_generate_netlink_event(u32 orig, enum events event)
>  {
>  	struct sk_buff *skb;
>  	struct nlattr *attr;
> @@ -1363,7 +1363,7 @@ int generate_netlink_event(u32 orig, enu
>  
>  	return result;
>  }
> -EXPORT_SYMBOL(generate_netlink_event);
> +EXPORT_SYMBOL(thermal_generate_netlink_event);
>  
>  static int genetlink_init(void)
>  {
> --- linux-3.1-rc2.orig/include/linux/thermal.h	2011-08-16 11:50:04.000000000 +0200
> +++ linux-3.1-rc2/include/linux/thermal.h	2011-08-17 22:36:47.000000000 +0200
> @@ -152,9 +152,9 @@ struct thermal_cooling_device *thermal_c
>  void thermal_cooling_device_unregister(struct thermal_cooling_device *);
>  
>  #ifdef CONFIG_NET
> -extern int generate_netlink_event(u32 orig, enum events event);
> +extern int thermal_generate_netlink_event(u32 orig, enum events event);
>  #else
> -static inline int generate_netlink_event(u32 orig, enum events event)
> +static inline int thermal_generate_netlink_event(u32 orig, enum events event)
>  {
>  	return 0;
>  }
> 
> 
> 

