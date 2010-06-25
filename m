Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0FYIFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:05:48 -0400
Received: from bamako.nerim.net ([62.4.17.28]:56616 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab0FYIFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:05:13 -0400
Date: Fri, 25 Jun 2010 10:05:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 3/4] hwmon: Update sysfs-interface to include new
 attributes
Message-ID: <20100625100509.7cf0e9fa@hyperion.delvare>
In-Reply-To: <1277416861-32494-4-git-send-email-guenter.roeck@ericsson.com>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
	<1277416861-32494-4-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Thu, 24 Jun 2010 15:01:00 -0700, Guenter Roeck wrote:
> Added _lcrit and _crit to voltage attributes. 
> Added _lcrit to temperature attributes.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/sysfs-interface |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index d4e2917..7f60c0d 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -107,10 +107,24 @@ in[0-*]_min	Voltage min value.
>  		Unit: millivolt
>  		RW
>  		
> +in[0-*]_lcrit	Voltage critical min value.
> +		Unit: millivolt
> +		RW
> +		If voltage drops to or below this limit, the system may
> +		take drastic action such as power down or reset. At the very
> +		least, it should report a fault.
> +
>  in[0-*]_max	Voltage max value.
>  		Unit: millivolt
>  		RW
>  		
> +in[0-*]_crit	Voltage critical max value.
> +		Unit: millivolt
> +		RW
> +		If voltage reaches or exceeds this limit, the system may
> +		take drastic action such as power down or reset. At the very
> +		least, it should report a fault.
> +
>  in[0-*]_input	Voltage input value.
>  		Unit: millivolt
>  		RO
> @@ -284,11 +298,16 @@ temp[1-*]_input Temperature input value.
>  		Unit: millidegree Celsius
>  		RO
>  
> -temp[1-*]_crit	Temperature critical value, typically greater than
> +temp[1-*]_crit	Temperature critical max value, typically greater than
>  		corresponding temp_max values.
>  		Unit: millidegree Celsius
>  		RW
>  
> +temp[1-*]_lcrit	Temperature critical min value, typically lower than
> +		corresponding temp_min values.
> +		Unit: millidegree Celsius
> +		RW
> +

I'd rather have you insert that one _after_ temp[1-*]_crit_hyst, as
temp[1-*]_crit_hyst is rightly related to temp[1-*]_crit.

>  temp[1-*]_crit_hyst
>  		Temperature hysteresis value for critical limit.
>  		Unit: millidegree Celsius

Other than this minor issue, which I have addresses myself, this patch
looks very good to me and I've applied it.

Thanks,
-- 
Jean Delvare
