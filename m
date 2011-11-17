Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1KQUFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:05:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55355 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab1KQUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:05:15 -0500
X-Sasl-enc: RxxVmkVcMpFsKCiQTo4JSkn6lQayJYw2XBe+7V8tq0wS 1321560314
Date: Thu, 17 Nov 2011 12:04:11 -0800
From: Greg KH <greg@kroah.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 1/5] drivercore: Generalize module_platform_driver
Message-ID: <20111117200411.GA8691@kroah.com>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
 <1321434819-23678-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321434819-23678-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:13:35AM +0100, Lars-Peter Clausen wrote:
> This patch generalizes the module_platform_driver macro and introduces a new
> module_driver macro. The module_driver macro takes a driver name, a register
> and a unregister function for this driver type. Using these it construct the
> module init and exit sections which register and unregister the driver. Since
> such init/exit sections are commonly found in drivers this macro can be used
> to eliminate a lot of boilerplate code.
> 
> The macro is not intended to be used by driver modules directly, instead it
> should be used to generate bus specific macros for registering drivers like
> the module_platform_driver macro.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Jonathan Cameron <jic23@kernel.org>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  include/linux/init.h            |   21 +++++++++++++++++++++

I've moved this from init.h (which is trying to get away from
module-specific stuff) to device.h, which is where this really should
be.

thanks,

greg k-h
