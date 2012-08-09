Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030691Ab2HIOmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:42:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49965 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785Ab2HIOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:42:40 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 9 Aug 2012 07:42:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: NULL dereference BUG in sch56xx_init()
Message-ID: <20120809144239.GA6604@roeck-us.net>
References: <20120809125526.GA11926@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809125526.GA11926@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 08:55:26PM +0800, Fengguang Wu wrote:
> Hi Guenter,
> 
> This commit triggered an oops which can be fixed by the attached diff.
> Should it be folded into the original one (preferable for me), or be
> resent as a standalone patch?
> 
I folded it into the original commit.

Thanks a lot for the test and feedback!

Guenter

[ ... ]

> diff --git a/drivers/hwmon/sch56xx-common.c b/drivers/hwmon/sch56xx-common.c
> index 69abbf7..d00b30a 100644
> --- a/drivers/hwmon/sch56xx-common.c
> +++ b/drivers/hwmon/sch56xx-common.c
> @@ -554,7 +554,7 @@ exit:
>  	return err;
>  }
>  
> -static int __init sch56xx_device_add(unsigned short address, const char *name)
> +static int __init sch56xx_device_add(int address, const char *name)
>  {
>  	struct resource res = {
>  		.start	= address,
> @@ -594,7 +594,7 @@ exit_device_put:
>  
>  static int __init sch56xx_init(void)
>  {
> -	unsigned short address;
> +	int address;
>  	const char *name = NULL;
>  
>  	address = sch56xx_find(0x4e, &name);

