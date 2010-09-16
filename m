Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0IPPO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:14:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13100 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0IPPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:14:55 -0400
Date: Thu, 16 Sep 2010 17:14:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (adm1031) Replace update_rate sysfs
 attribute with update_interval
Message-ID: <20100916171443.0322bdb6@hyperion.delvare>
In-Reply-To: <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	<1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 19:07:14 -0700, Guenter Roeck wrote:
> The attribute reflects an interval, not a rate.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/sysfs-interface |   12 +++++-----
>  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
>  2 files changed, 30 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index ff45d1f..df0cdd2 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -91,13 +91,13 @@ name		The chip name.
>  		I2C devices get this attribute created automatically.
>  		RO
>  
> -update_rate	The rate at which the chip will update readings.
> -		Unit: millisecond
> +update_interval	The interval at which the chip or driver will update readings.

I think I prefer the original wording. The attribute is really about
setting the register refresh rate at the hardware level. The fact that
register cache lifetime in the driver can be adjusted accordingly is an
optional implementation detail IMHO.

> +		Unit: milliseconds

Why change? All other units are singular in the file.

>  		RW
> -		Some devices have a variable update rate. This attribute
> -		can be used to change the update rate to the desired
> -		frequency.
> -

Killing an innocent blank line ;)

> +		Some devices have a variable update rate or interval.
> +		Some drivers may want to make the update interval configurable
> +		instead of using a hardcoded value. This attribute can be used
> +		to change the update interval to the desired value.
>  
>  ************
>  * Voltages *

I'm fine with all the rest.

-- 
Jean Delvare
