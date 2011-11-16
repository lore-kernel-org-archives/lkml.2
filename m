Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1KPQgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:36:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46721 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1KPQgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:36:37 -0500
Date: Wed, 16 Nov 2011 17:36:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <gregkh@suse.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 0/5] Generalize module_platform_driver
Message-ID: <20111116173618.0a847852@endymion.delvare>
In-Reply-To: <20111116160206.GA27049@suse.de>
References: <1321434819-23678-1-git-send-email-lars@metafoo.de>
	<20111116160206.GA27049@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 08:02:06 -0800, Greg KH wrote:
> On Wed, Nov 16, 2011 at 10:13:34AM +0100, Lars-Peter Clausen wrote:
> > Grant Likely recently introduced the module_platform_driver macro which can be
> > used to eliminate a few lines on boilerplate code in platform driver modules.
> > The same approach can be used to do the same for other bus type drivers.
> > 
> > The first patch of this series generalizes the module_platform_driver macro and
> > introduces the module_driver macro. It is similar to module_platform_driver
> > macro but has two additional parameters to pass in the driver register and
> > unregister function. The intend is that this macro is used to construct bus
> > specific macros for generating the driver register/unregister boilerplate code.
> > 
> > The next two patches in this series add the module_i2c_driver and
> > module_spi_driver macro which use the module_driver macro to generate the I2C
> > and SPI driver boilerplate code.
> > 
> > The last two patches convert the driver found in the IIO framework to use the
> > new module_i2c_driver and module_spi_driver macros to demonstrate their
> > potential and remove over 700 lines of code.
> > 
> > While this series only introduces these kind of helper macros for I2C and SPI
> > bus drivers the same scheme should be applicable to most other bus driver types.
> > For example PCI and USB seem to be good candidates.
> > 
> > It probably makes sense to merge the first three patches together. The last two
> > can probably, since this is not urgent, wait until the first three have reached
> > mainline.
> 
> Nice, I like this, unless people object, I'll merge the first patch to
> the driver-core tree.
> 
> I'll gladly take the i2c and spi patches as well if the subsystem
> maintainers there don't object, and I'll work on the USB patch as well.

No objection from me (for i2c).

-- 
Jean Delvare
