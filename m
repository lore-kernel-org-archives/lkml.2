Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0KBQEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:04:38 -0400
Received: from imr4.ericy.com ([198.24.6.8]:43579 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab0KBQEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:04:32 -0400
Date: Tue, 2 Nov 2010 09:03:43 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/8] hwmon: applesmc: Relax the severity
 of device init failure
Message-ID: <20101102160343.GA30515@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Oct 31, 2010 at 03:50:27AM -0400, Henrik Rydberg wrote:
> The device init is used to reset the accelerometer. Failure to reset
> is not severe enough to stop loading the module or to resume from
> hibernation.  This patch relaxes failure to a warning and drops
> output in case of success.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |   24 ++----------------------
>  1 files changed, 2 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index d7a5b75..375e464 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -458,21 +458,8 @@ static int applesmc_device_init(void)
>  	mutex_lock(&applesmc_lock);
>  
Since the callers of applesmc_device_init() now all don't check the return value,
it might make sense to declare it as void and not bother returning an error.

Otherwise looks good.

Thanks,
Guenter
