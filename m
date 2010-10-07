Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0JGVnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:43:43 -0400
Received: from kroah.org ([198.145.64.141]:56164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0JGVnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:43:41 -0400
Date: Thu, 7 Oct 2010 14:41:37 -0700
From: Greg KH <greg@kroah.com>
To: rklein@nvidia.com
Cc: jic23@cam.ac.uk, joe@perches.com, achew@nvidia.com, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, ldewangan@nvidia.com
Subject: Re: [PATCH v5] staging: iio: light: Adding driver for ISL29018 ALS
Message-ID: <20101007214137.GA9269@kroah.com>
References: <1286480883-25589-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286480883-25589-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 12:48:03PM -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> adding support for the ISL 29018 ambient light and proximity sensor.
> 
> Addressed comments from reviews by Jonathan Cameron and Joe Perches
>   * Removed some excess dbg prints that only printed function name
>   * Renamed some properties to make them more descriptive
>   * Added a property to list available adc resolutions
>   * Defined arrays for resolutions/ranges as static const
>   * Change loops initialization to memset for extensibility.
>     * used sizeof() instead of ARRAY_SIZE() to be safer
>   * Added a property to list available adc ranges
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

Too bad no one actually compiled this driver:
  CC [M]  drivers/staging/iio/light/isl29018.o
drivers/staging/iio/light/isl29018.c:420:8: error: ‘show_prox_infrared_suppression’ undeclared here (not in a function)
drivers/staging/iio/light/isl29018.c:433:1: error: ‘iio_dev_attr_range_available’ undeclared here (not in a function)
drivers/staging/iio/light/isl29018.c:435:1: error: ‘iio_dev_attr_adc_resolution_available’ undeclared here (not in a function)
drivers/staging/iio/light/isl29018.c: In function ‘isl29018_chip_init’:
drivers/staging/iio/light/isl29018.c:451:6: warning: unused variable ‘i’
drivers/staging/iio/light/isl29018.c: At top level:
drivers/staging/iio/light/isl29018.c:350:16: warning: ‘show_prox_infrared_supression’ defined but not used
drivers/staging/iio/light/isl29018.c:416:1: warning: ‘iio_const_attr_range_available’ defined but not used
drivers/staging/iio/light/isl29018.c:417:1: warning: ‘iio_const_attr_adc_resolution_available’ defined but not used
make[2]: *** [drivers/staging/iio/light/isl29018.o] Error 1
make[1]: *** [drivers/staging/iio/light] Error 2
make: *** [_module_drivers/staging/iio] Error 2

Please fix this up before resending it.

thanks,

greg k-h
