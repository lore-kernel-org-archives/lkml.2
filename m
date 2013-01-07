Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3AGT0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:26:08 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48582 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab3AGT0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:26:06 -0500
Date: Mon, 7 Jan 2013 11:26:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 3/9] Thermal: Add APIs to bind cdev to new zone structure
Message-ID: <20130107192602.GD4465@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-4-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357542806-20449-4-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:43:20PM +0530, Durgadoss R wrote:
> +struct thermal_cooling_device *get_cdev_by_name(const char *name)
> +{
> +	struct thermal_cooling_device *pos;
> +	struct thermal_cooling_device *cdev = NULL;
> +
> +	mutex_lock(&cdev_list_lock);
> +	for_each_cdev(pos) {
> +		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
> +			cdev = pos;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&cdev_list_lock);
> +	return cdev;
> +}
> +EXPORT_SYMBOL(get_cdev_by_name);

EXPORT_SYMBOL_GPL?

You also forgot to increment the reference count, which is required for
all reference counted objects.

thanks,

greg k-h
