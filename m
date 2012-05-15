Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2EPPiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:38:13 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:34759 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab2EPPiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:38:12 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2012 11:38:12 EDT
Date: Tue, 15 May 2012 09:29:19 -0400
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Generic ADC support for hwmon
Message-ID: <20120515132919.GA11693@jake.ruivo.org>
References: <1337092008-31263-1-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337092008-31263-1-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jenny,
On Tue, May 15, 2012 at 07:56:48PM +0530, Jenny TC wrote:
> --- /dev/null
> +++ b/drivers/hwmon/hwmon-adc.c
> @@ -0,0 +1,212 @@
> +/*
> + *  hwmon-adc.c - Generic adc support for hardware monitoring  subsystem.
> + *
> + *  Copyright (C) 2012 Intel Corp
> + *
> + *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but
> + *  WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *  General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License along
> + *  with this program; if not, write to the Free Software Foundation, Inc.,
> + *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> + * Author : Jenny TC <jenny.tc@intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-adc.h>
> +
> +LIST_HEAD(adc_lst);
> +DEFINE_MUTEX(list_lock);
need static here?

> +struct device *hwmon_adc_device_register(struct device *dev,
> +					 struct hwmon_adc_ops *adc_ops)
> +{
> +	struct hwmon_adc *adc_node;
> +	struct device *hwdev;
> +
> +	hwdev = hwmon_device_register(dev);
> +	if (IS_ERR(hwdev))
> +		return hwdev;
> +
> +	adc_node = kzalloc(sizeof(struct hwmon_adc), GFP_ATOMIC);
why are you using GFP_ATOMIC here? and you need to handle the case when the
allocation fails

-- 
Aristeu

