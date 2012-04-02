Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2DBSpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:45:38 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:46855 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2DBSph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:45:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B2C6@exchsrvr.taosinc.com> <20120402180544.GA21374@kroah.com> <B4B07CCC7B7A084E989CF9386538EA1D0120B2F0@exchsrvr.taosinc.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D0120B2F0@exchsrvr.taosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: RE: TAOS Color sensor
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Mon, 02 Apr 2012 19:45:30 +0100
To: Jon Brenner <jbrenner@TAOSinc.com>, Greg KH <gregkh@linuxfoundation.org>
CC: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <38093b96-d358-4266-bc14-504bff962b5f@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jon Brenner <jbrenner@TAOSinc.com> wrote:

>Hi Greg,
>Please see comments below.
>
>Jon
>
>> -----Original Message-----
>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>> Sent: Monday, April 02, 2012 1:06 PM
>> To: Jon Brenner
>> Cc: jic23@kernel.org; linux-iio@vger.kernel.org;
>linux-kernel@vger.kernel.org
>> Subject: Re: TAOS Color sensor
>> 
>> On Mon, Apr 02, 2012 at 12:28:39PM -0500, Jon Brenner wrote:
>> > There is a need to release a driver for the TAOS tsl3x7x family of
>> > COLOR sensors.
>> > The driver provides Lux (clear and IR) , Proximity, Color
>temperature
>> > (calculated CCT) and raw - red, green, and blue data channels.
>> > Currently I do not think the IIO subsystem provides for CT or RGB
>data
>> > channels.
>> > Is this correct?
>> > What can be done to accommodate it and who can do it?
>> 
>> Do you have a driver written already for this?  What is the interface
>to the
>> device?  If this can this use the v4l layer to get the color channel
>information out
>> to userspace?
>
>Driver is in development - near ready - customers waiting.
>The device tsl3x7x device interface is i2c.
>The RGBC is used to promote both ALS sensing (Lux and intensity) and
>Color Temp.  Proximity sensing is also available on some 3x7x devices.
>The driver takes into account the type (thickness, color, aperture
>size,
>etc.) of the glass it's behind (typically in phones, tvs. Etc) and
>computes ALS and CT.
>RGB can help provide more precise Lux - esp. under florescent lighting.
>Raw RGB data is available (as is clear and IR)  - via sysfs.
>While I can map the RGB for channels, there doesn't appear to be an IIO
>virtual channel name (such as LIGHT - for computed ALS) defined for CT.
>It would also be nice to have RGB channel designation established.
Congratulations! You get to propose a suitable interface...

Best option is probably a patch to the sysfs docs covering the new elements.

Could do it in userspace but with interrupts and existing interface for other part elements seems reasonable to be in kernel to me...
>
>
>> 
>> Or is this needed to be done in the kernel at all, lots of color
>sensors are driven
>> by libusb today, like the one on my desk at the moment, no kernel
>changes
>> needed at all.
>> 
>> thansk,
>> 
>> greg k-h
>--
>To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
