Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2I0Lex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:34:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:33381 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2I0Lev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:34:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,495,1344236400"; 
   d="scan'208";a="214307378"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: RE: [PATCH 2/2] thermal: user_space: Add missing static storage
 class specifiers
Thread-Topic: [PATCH 2/2] thermal: user_space: Add missing static storage
 class specifiers
Thread-Index: AQHNnKO11aYMIfHs6Ue6Lwr9zgOohpeeDsDQ
Date: Thu, 27 Sep 2012 11:34:47 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591D4273@BGSMSX101.gar.corp.intel.com>
References: <1348745274-15936-1-git-send-email-sachin.kamat@linaro.org>
 <1348745274-15936-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348745274-15936-2-git-send-email-sachin.kamat@linaro.org>
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
> Subject: [PATCH 2/2] thermal: user_space: Add missing static storage class
> specifiers
> 
> Fixes the following sparse warnings:
> drivers/thermal/user_space.c:38:5: warning:
> symbol 'notify_user_space' was not declared. Should it be static?
> drivers/thermal/user_space.c:46:25: warning:
> symbol 'thermal_gov_user_space' was not declared. Should it be static?

Looks fine. Thanks for the two patches :-)

Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/thermal/user_space.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/user_space.c b/drivers/thermal/user_space.c
> index fb246b90..6bbb380 100644
> --- a/drivers/thermal/user_space.c
> +++ b/drivers/thermal/user_space.c
> @@ -35,7 +35,7 @@
>   *
>   * This function notifies the user space through UEvents.
>   */
> -int notify_user_space(struct thermal_zone_device *tz, int trip)
> +static int notify_user_space(struct thermal_zone_device *tz, int trip)
>  {
>  	mutex_lock(&tz->lock);
>  	kobject_uevent(&tz->device.kobj, KOBJ_CHANGE);
> @@ -43,7 +43,7 @@ int notify_user_space(struct thermal_zone_device *tz,
> int trip)
>  	return 0;
>  }
> 
> -struct thermal_governor thermal_gov_user_space = {
> +static struct thermal_governor thermal_gov_user_space = {
>  	.name		= "user_space",
>  	.throttle	= notify_user_space,
>  	.owner		= THIS_MODULE,
> --
> 1.7.4.1

