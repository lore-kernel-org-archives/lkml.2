Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2GVK6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 06:58:30 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:29750 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2GVK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 06:58:28 -0400
Date: Sun, 22 Jul 2012 12:58:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Devendra Naga <develkernel412222@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <wfg@linux.intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
Message-ID: <20120722125810.052ca19e@endymion.delvare>
In-Reply-To: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2012 13:55:22 +0545, Devendra Naga wrote:
> with the commit 67ff19 (Thermal: Make Thermal trip points writeable)
> build error is introduced,
> 
> the following was reported from Fengguang Wu,
> 
> drivers/thermal/thermal_sys.c: In function 'create_trip_attrs':
> drivers/thermal/thermal_sys.c:1216:3: error: 'count' undeclared (first use in this function)
> drivers/thermal/thermal_sys.c:1216:3: note: each undeclared identifier is reported only once for each function it appears in
> 
> link:
> http://www.spinics.net/lists/linux-kernel-janitors/msg12174.html
> 
> use the indx instead.

Thanks for the fix.

> Cc: Durgadoss R <durgadoss.r@intel.com>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> ---
> 
> This patch is build-tested only.

Something the original submitter apparently didn't do. Durga, can you
please build-test all your commits from now on? I don't even understand
how you managed to test your code if it did not build...

The broken commit isn't upstream yet, so in the interest of
bisectability I would recommend that the original commit is fixed and
the branch in which this broken commit was is rebased. Only then, ask
Linux to pull from it.

Thanks.

> 
>  drivers/thermal/thermal_sys.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 9f56250..1b4aa9d 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1259,7 +1259,7 @@ static int create_trip_attrs(struct thermal_zone_device *tz, int flag)
>  		snprintf(tz->trip_type_attrs[indx].name, THERMAL_NAME_LENGTH,
>  			 "trip_point_%d_type", indx);
>  
> -		sysfs_attr_init(&tz->trip_type_attrs[count].attr.attr);
> +		sysfs_attr_init(&tz->trip_type_attrs[indx].attr.attr);
>  		tz->trip_type_attrs[indx].attr.attr.name =
>  						tz->trip_type_attrs[indx].name;
>  		tz->trip_type_attrs[indx].attr.attr.mode = S_IRUGO;

-- 
Jean Delvare
