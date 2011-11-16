Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1KPQND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:13:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1KPQNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:13:01 -0500
Date: Wed, 16 Nov 2011 08:02:06 -0800
From: Greg KH <gregkh@suse.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 0/5] Generalize module_platform_driver
Message-ID: <20111116160206.GA27049@suse.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321434819-23678-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:13:34AM +0100, Lars-Peter Clausen wrote:
> Grant Likely recently introduced the module_platform_driver macro which can be
> used to eliminate a few lines on boilerplate code in platform driver modules.
> The same approach can be used to do the same for other bus type drivers.
> 
> The first patch of this series generalizes the module_platform_driver macro and
> introduces the module_driver macro. It is similar to module_platform_driver
> macro but has two additional parameters to pass in the driver register and
> unregister function. The intend is that this macro is used to construct bus
> specific macros for generating the driver register/unregister boilerplate code.
> 
> The next two patches in this series add the module_i2c_driver and
> module_spi_driver macro which use the module_driver macro to generate the I2C
> and SPI driver boilerplate code.
> 
> The last two patches convert the driver found in the IIO framework to use the
> new module_i2c_driver and module_spi_driver macros to demonstrate their
> potential and remove over 700 lines of code.
> 
> While this series only introduces these kind of helper macros for I2C and SPI
> bus drivers the same scheme should be applicable to most other bus driver types.
> For example PCI and USB seem to be good candidates.
> 
> It probably makes sense to merge the first three patches together. The last two
> can probably, since this is not urgent, wait until the first three have reached
> mainline.

Nice, I like this, unless people object, I'll merge the first patch to
the driver-core tree.

I'll gladly take the i2c and spi patches as well if the subsystem
maintainers there don't object, and I'll work on the USB patch as well.

thanks,

greg k-h
