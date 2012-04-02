Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2DBSh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:37:58 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:21692 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753068Ab2DBSh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:37:56 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: TAOS Color sensor
Date: Mon, 2 Apr 2012 13:43:43 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D0120B2F0@exchsrvr.taosinc.com>
In-Reply-To: <20120402180544.GA21374@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: TAOS Color sensor
Thread-Index: Ac0Q/AuwzMLKQ6vTQJm2cjCSiZ+j/gAAVofQ
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B2C6@exchsrvr.taosinc.com> <20120402180544.GA21374@kroah.com>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
Please see comments below.

Jon

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, April 02, 2012 1:06 PM
> To: Jon Brenner
> Cc: jic23@kernel.org; linux-iio@vger.kernel.org;
linux-kernel@vger.kernel.org
> Subject: Re: TAOS Color sensor
> 
> On Mon, Apr 02, 2012 at 12:28:39PM -0500, Jon Brenner wrote:
> > There is a need to release a driver for the TAOS tsl3x7x family of
> > COLOR sensors.
> > The driver provides Lux (clear and IR) , Proximity, Color
temperature
> > (calculated CCT) and raw - red, green, and blue data channels.
> > Currently I do not think the IIO subsystem provides for CT or RGB
data
> > channels.
> > Is this correct?
> > What can be done to accommodate it and who can do it?
> 
> Do you have a driver written already for this?  What is the interface
to the
> device?  If this can this use the v4l layer to get the color channel
information out
> to userspace?

Driver is in development - near ready - customers waiting.
The device tsl3x7x device interface is i2c.
The RGBC is used to promote both ALS sensing (Lux and intensity) and
Color Temp.  Proximity sensing is also available on some 3x7x devices.
The driver takes into account the type (thickness, color, aperture size,
etc.) of the glass it's behind (typically in phones, tvs. Etc) and
computes ALS and CT.
RGB can help provide more precise Lux - esp. under florescent lighting.
Raw RGB data is available (as is clear and IR)  - via sysfs.
While I can map the RGB for channels, there doesn't appear to be an IIO
virtual channel name (such as LIGHT - for computed ALS) defined for CT.
It would also be nice to have RGB channel designation established.


> 
> Or is this needed to be done in the kernel at all, lots of color
sensors are driven
> by libusb today, like the one on my desk at the moment, no kernel
changes
> needed at all.
> 
> thansk,
> 
> greg k-h
