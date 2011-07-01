Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1GADKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:10:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1GADKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:10:00 -0400
Date: Thu, 30 Jun 2011 20:09:04 -0700
From: Greg KH <gregkh@suse.de>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
Message-ID: <20110701030904.GA3748@suse.de>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 07:18:17PM -0700, Nathan Royer wrote:
> This files defines the userspace interface and how to integrate it into a
> platform.
> 
> Signed-off-by: Nathan Royer <nroyer@invensense.com>
> ---
> 
> This is the first of many patch files for the inv_mpu driver in its current
> state.  This is our first time submitting this driver, so I expect there to be
> a lot wrong with it, and expect to need to fix many things.
> 
> The inv_mpu driver attepts to implement a Motion Processing Unit interface.  As
> a unit, an accelerometer, magnetometer, gyroscope, and/or altimiter data is
> fused together to produce calibrated data and a quaternion.
> 
> The inv_mpu driver interface is currently implemented as a misc device, but may
> need to change to include both sysfs attributes and input devices.  I think
> that we will continue to need the ioctl interface, but many of the ioctls can
> be replace by attributes and/or input devices.
> 
> The mpu3050 has an i2c master interface designed to control an accelerometer
> and a Digital Motion Processor (DMP) used to perform sensor fusion on the
> gyroscope and accelerometer.  This data is then read out of the mpu3050 fifo
> and sent to userspace for distribution and optional propritary processing, such
> as fusion with a compass to produce a 9 axis quaternion.
> 
> Some question I have at the start are:
> 1) Is there a master design or standard interface for Motion Processing
> devices, specifically ones that do calibration, sensor fusion, and or have a
> micro-controller to do some of this work.
> 2) Is there a standard way to integrate user space components with kernel side
> components.
> 3) Should data be pushed back to the driver from userspace, and made available
> as an input device or should it remain as a character device.
> 4) Can a 4 element quaternion be added to input.h:
> ABS_QUATERNION_1 ABS_QUATERNION_I ABS_QUATERNION_J ABS_QUATERNION_K
> for <1, i, j, k>
> 5) Should we instead use a rotation vector as defined in the Android sensor:
> http://developer.android.com/reference/android/hardware/SensorEvent.html
> 6) Are there any other major design concerns?

Shouldn't you be using the iio subsystem for the kernel/user interface
as I think it handles most of this for you already, right?

> 7) Can an input device also have a character device interface for proprietary
> customization.

What do you mean by this?

greg k-h
