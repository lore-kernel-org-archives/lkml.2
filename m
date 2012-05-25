Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2EYFLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 01:11:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2EYFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 01:10:59 -0400
Date: Fri, 25 May 2012 14:10:51 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
        Carmine Iascone <carmine.iascone@st.com>,
        Matteo Dameno <matteo.dameno@st.com>
Subject: Re: LIS331DLH accelerometer driver, IIO or not?
Message-ID: <20120525051051.GA3135@kroah.com>
References: <4FBF0AC1.6030406@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBF0AC1.6030406@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:29:53PM -0700, Darren Hart wrote:
> I'm working to enable the LIS331DLH accelerometer on the Fish River
> Island II embedded atom development kit.
> 
> http://www.st.com/internet/analog/product/218132.jsp
> 
> http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html
> 
> This device is attached to an i2c bus implemented in a CPLD (complex
> programmable logic device) integrated on the compute module. I found an
> IIO driver for the device written for 2.6.34. I've rewritten most of the
> driver to work with the 3.2 kernel's IIO subsystem (and had planned to
> next port it all the way to git HEAD and push it upstream).
> 
> However, I've since stumbled across a couple of things which cloud the
> issue for me.
> 
> First, Carmine Iascone submitted a driver (driver/misc, not iio) for the
> LIS331DLH back in Nov 2010.
> 
> http://lkml.org/lkml/2010/11/9/369
> 
> It was suggested that this driver be merged with the existing lis3lv02d
> driver which listed support for a similar chip in the header, LIS331DL,
> but it also lists LIS331DLF as not supported. The current git HEAD still
> does not list LIS331DLH, and there is not a compatible register map in
> the header.
> 
> Second, I came across the following TI document for porting the
> LIS331DLH driver for Android:
> 
> http://processors.wiki.ti.com/index.php/TI-Android-GingerBread-2.3.4-DevKit-2.1_PortingGuides
> 
> This references a lis331dlh.c driver which I do not find in Linus' git
> repository nor in linux-next.
> 
> So there are 3 ways I can go about this, and I'd appreciate any
> direction on which would be the most acceptable for merging upstream.
> 
> 1) Continue with my IIO version. This subsystem seems well suited to the
> accelerometer. The iio_chan_spec simplifies the task of exposing the
> event capabilities of the device, which the drivers/misc/lis3lv02d
> driver mostly glosses over. It only supports events on free-fall for
> example, while with IIO it is straight forward to enable interrupts for
> rising and/or falling thresholds for each axis independently.
> 
> 2) Attempt to merge Carmine's drivers/misc/lis331dlh driver with the
> existing lis3lv02d driver as suggested in the thread mentioned above.
> This driver isn't as fully functional.
> 
> 3) Try and dig up the lis331dlh driver referenced in the TI document and
> work to get that upstream. Like option 2, this driver is not likely to
> be as configurable as the IIO driver.
> 
> I am more interested in enabling people to do bizarre and interesting
> things with the device, so I'm leaning toward continuing with my IIO
> implementation.

Make it an IIO driver and then we can delete the misc driver, which
shouldn't have snuck in there in the first place :)

greg k-h
