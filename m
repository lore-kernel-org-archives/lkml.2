Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2I0Len (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:34:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:3563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2I0Lem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,495,1344236400"; 
   d="scan'208";a="214307080"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: RE: [PATCH 1/2] thermal: fair_share: Add missing static storage
 class specifiers
Thread-Topic: [PATCH 1/2] thermal: fair_share: Add missing static storage
 class specifiers
Thread-Index: AQHNnKOzZm8R+xpbDkScB1Yb3j7ew5eeDpnA
Date: Thu, 27 Sep 2012 11:34:10 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D4267@BGSMSX101.gar.corp.intel.com>
References: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
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
> Sent: Thursday, September 27, 2012 4:58 PM
> To: linux-kernel@vger.kernel.org
> Cc: R, Durgadoss; Zhang, Rui; sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 1/2] thermal: fair_share: Add missing static storage class
> specifiers
> 
> Fixes the following sparse warnings:
> drivers/thermal/fair_share.c:80:5: warning:
> symbol 'fair_share_throttle' was not declared. Should it be static?
> drivers/thermal/fair_share.c:111:25: warning:
> symbol 'thermal_gov_fair_share' was not declared. Should it be static?
> 
Looks fine.
Acked-by: Durgadoss R <Durgadoss.r@intel.com>

Thanks,
Durga

> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/thermal/fair_share.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
> index 5d3a7a3..792479f 100644
> --- a/drivers/thermal/fair_share.c
> +++ b/drivers/thermal/fair_share.c
> @@ -77,7 +77,7 @@ static long get_target_state(struct
> thermal_zone_device *tz,
>   *	(Heavily assumes the trip points are in ascending order)
>   * new_state of cooling device = P3 * P2 * P1
>   */
> -int fair_share_throttle(struct thermal_zone_device *tz, int trip)
> +static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
>  {
>  	const struct thermal_zone_params *tzp;
>  	struct thermal_cooling_device *cdev;
> @@ -108,7 +108,7 @@ int fair_share_throttle(struct thermal_zone_device
> *tz, int trip)
>  	return 0;
>  }
> 
> -struct thermal_governor thermal_gov_fair_share = {
> +static struct thermal_governor thermal_gov_fair_share = {
>  	.name		= "fair_share",
>  	.throttle	= fair_share_throttle,
>  	.owner		= THIS_MODULE,
> --
> 1.7.4.1

