Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2I0LQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:16:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:32292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab2I0LQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:16:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,495,1344236400"; 
   d="scan'208";a="214298966"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: RE: [PATCH] thermal: step_wise: Add missing static storage class
 specifiers
Thread-Topic: [PATCH] thermal: step_wise: Add missing static storage class
 specifiers
Thread-Index: AQHNnJ+SuBKpTaE2+kamcfIr1wyF25eeCTaA
Date: Thu, 27 Sep 2012 11:15:22 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D41F5@BGSMSX101.gar.corp.intel.com>
References: <1348743492-30852-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348743492-30852-1-git-send-email-sachin.kamat@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Thursday, September 27, 2012 4:28 PM
> To: linux-kernel@vger.kernel.org
> Cc: R, Durgadoss; Zhang, Rui; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH] thermal: step_wise: Add missing static storage class
> specifiers
> 
> Fixes the following sparse warnings:
> drivers/thermal/step_wise.c:153:5: warning:
> symbol 'step_wise_throttle' was not declared. Should it be static?
> drivers/thermal/step_wise.c:172:25: warning:
> symbol 'thermal_gov_step_wise' was not declared. Should it be static?

Looks fine.
Acked-by: Durgadoss R <durgadoss.r@intel.com>

Care to fix the same things in fair_share.c and user_space.c ?

Thanks,
Durga

> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/thermal/step_wise.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> index 3f9cfcf..1242cff 100644
> --- a/drivers/thermal/step_wise.c
> +++ b/drivers/thermal/step_wise.c
> @@ -150,7 +150,7 @@ static void thermal_zone_trip_update(struct
> thermal_zone_device *tz, int trip)
>   * step. If the zone is 'cooling down' it brings back the performance of
>   * the devices by one step.
>   */
> -int step_wise_throttle(struct thermal_zone_device *tz, int trip)
> +static int step_wise_throttle(struct thermal_zone_device *tz, int trip)
>  {
>  	struct thermal_instance *instance;
> 
> @@ -169,7 +169,7 @@ int step_wise_throttle(struct thermal_zone_device
> *tz, int trip)
>  	return 0;
>  }
> 
> -struct thermal_governor thermal_gov_step_wise = {
> +static struct thermal_governor thermal_gov_step_wise = {
>  	.name		= DEFAULT_THERMAL_GOVERNOR,
>  	.throttle	= step_wise_throttle,
>  	.owner		= THIS_MODULE,
> --
> 1.7.4.1

