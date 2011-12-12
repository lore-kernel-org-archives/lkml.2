Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1LLScX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:32:23 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:33101 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1LLScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:32:19 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 13:32:19 EST
References: <9be2717594eec36bdcc072a90d81b044500270e4.1322593277.git.joe@perches.com> <96a258354ce375bf80259f783506bbd7191b520d.1322593277.git.joe@perches.com>
Message-ID: <cone.1323714410.432860.1894.1000@zopiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acerhdf: Message logging neatening
Date: Mon, 12 Dec 2011 19:26:50 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

thanks for sending this patch, I've got some comments on it.


Joe Perches writes:
> Use pr_warn not pr_warning.

Don't see any line, where you changed this…


> Coalesce formats.
> Argument aligning.
> Remove superfluous parentheses.

Discussed inline.


> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/acerhdf.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 833c0ec..639db4d 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -262,12 +262,11 @@ static void acerhdf_change_fanstate(int state)
>  	unsigned char cmd;
>  
>  	if (verbose)
> -		pr_notice("fan %s\n", (state == ACERHDF_FAN_OFF) ?
> -				"OFF" : "ON");
> +		pr_notice("fan %s\n", state == ACERHDF_FAN_OFF ? "OFF" : "ON");

In my opinion the one with brackets is easier to read.


>  	if ((state != ACERHDF_FAN_OFF) && (state != ACERHDF_FAN_AUTO)) {
>  		pr_err("invalid fan state %d requested, setting to auto!\n",
> -			state);
> +		       state);

Is it written somewhere to use spaces instead of a tab in such cases? I like 
tab more. (1)


>  		state = ACERHDF_FAN_AUTO;
>  	}
>  
> @@ -282,19 +281,18 @@ static void acerhdf_check_param(struct thermal_zone_device *thermal)
>  {
>  	if (fanon > ACERHDF_MAX_FANON) {
>  		pr_err("fanon temperature too high, set to %d\n",
> -				ACERHDF_MAX_FANON);
> +		       ACERHDF_MAX_FANON);

see (1). - but maybe one tab shall be removed.


>  		fanon = ACERHDF_MAX_FANON;
>  	}
>  
>  	if (kernelmode && prev_interval != interval) {
>  		if (interval > ACERHDF_MAX_INTERVAL) {
>  			pr_err("interval too high, set to %d\n",
> -				ACERHDF_MAX_INTERVAL);
> +			       ACERHDF_MAX_INTERVAL);

see (1).


>  			interval = ACERHDF_MAX_INTERVAL;
>  		}
>  		if (verbose)
> -			pr_notice("interval changed to: %d\n",
> -					interval);
> +			pr_notice("interval changed to: %d\n", interval);

I agree on this.


>  		thermal->polling_delay = interval*1000;
>  		prev_interval = interval;
>  	}
> @@ -605,8 +603,8 @@ static int acerhdf_check_hardware(void)
>  	}
>  
>  	if (!bios_cfg) {
> -		pr_err("unknown (unsupported) BIOS version %s/%s/%s, "
> -			"please report, aborting!\n", vendor, product, version);
> +		pr_err("unknown (unsupported) BIOS version %s/%s/%s, please report, aborting!\n",
> +		       vendor, product, version);

disagree, as it exceeds 80 chars.


>  		return -EINVAL;
>  	}
>  
> @@ -616,8 +614,7 @@ static int acerhdf_check_hardware(void)
>  	 */
>  	if (!kernelmode) {
>  		pr_notice("Fan control off, to enable do:\n");
> -		pr_notice("echo -n \"enabled\" > "
> -			"/sys/class/thermal/thermal_zone0/mode\n");
> +		pr_notice("echo -n \"enabled\" > /sys/class/thermal/thermal_zone0/mode\n");

disagree, as it exceeds 80 chars when using tabstop=8.


>  	}
>  
>  	return 0;
> -- 
> 1.7.6.405.gc1be0
> 

--
kind regards,
--peter;
