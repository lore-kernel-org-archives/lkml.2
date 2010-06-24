Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0FXXco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 19:32:44 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57689 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0FXXcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 19:32:42 -0400
Date: Thu, 24 Jun 2010 16:32:40 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 3/4] hwmon: Update sysfs-interface to include new
 attributes
Message-ID: <20100624233240.GA9934@ovro.caltech.edu>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
 <1277416861-32494-4-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277416861-32494-4-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 24 Jun 2010 16:32:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 03:01:00PM -0700, Guenter Roeck wrote:
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

The critical voltages API looks good to me.

I have a hwmon chip driver for the TI INA209 (which Jean NAK'd) that
could use these limits. I'll submit it again soon with changes to use
this new set of sysfs attributes.

It would be great to see a patch to libsensors and the sensors program
to allow it to display these limits too.

Thanks,
Ira

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
>  temp[1-*]_crit_hyst
>  		Temperature hysteresis value for critical limit.
>  		Unit: millidegree Celsius
> -- 
> 1.7.0.87.g0901d
> 
