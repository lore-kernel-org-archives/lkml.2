Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KECYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:24:45 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33296 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0KECYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:24:41 -0400
Date: Thu, 4 Nov 2010 19:23:48 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 3/8] hwmon: applesmc: Dynamic creation of
 temperature files
Message-ID: <20101105022348.GA28308@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-4-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-4-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:29AM -0400, Henrik Rydberg wrote:
> The current driver creates temperature files based on a list
> of temperature keys given per device. Apart from slow adaption
> to new machine models, the number of sensors also depends on
> the number of processors. This patch looks up the temperature
> keys dynamically, thereby supporting all models.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,

Nice cleanup. Just a coule of minor comments.

> ---
>  drivers/hwmon/applesmc.c |  498 +++++++++++-----------------------------------
>  1 files changed, 113 insertions(+), 385 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 7f030f0..0207618 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
[ ...]
> 
> -       pr_info("key=%d\n", s->key_count);
> +       pr_info("key=%d temp=%d\n", s->key_count, s->temp_count);

Is this useful or just noisy ? How about pr_debug instead ?

> 
>         return 0;
>  }

[ ... ] 

> @@ -1429,13 +1122,66 @@ static int applesmc_dmi_match(const struct dmi_system_id *id)
>         pr_info(" - Model %s light sensors and backlight\n",
>                 applesmc_light ? "with" : "without");
> 
> -       applesmc_temperature_set =  dmi_data->temperature_set;
> -       while (temperature_sensors_sets[applesmc_temperature_set][i] != NULL)
> -               i++;
> -       pr_info(" - Model with %d temperature sensors\n", i);
> +

This results in another double empty line.

Guenter
