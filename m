Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1GFBtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:49:51 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46439 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753326Ab1GFBtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:49:49 -0400
From: Nathan Royer <nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<4E0D8E94.5030604@cam.ac.uk>	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
	<4E105284.7030209@cam.ac.uk> <20110704091658.0d4c8e3f@bob.linux.org.uk>
In-Reply-To: <20110704091658.0d4c8e3f@bob.linux.org.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acw6IrqM09GNmGyZQXCkTfAElV9ikABTGaOw
Date: Tue, 5 Jul 2011 18:49:47 -0700
Message-ID: <c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>
Subject: RE: [PATCH 01/11] misc: inv_mpu primary header file and README file.
To: Alan Cox <alan@linux.intel.com>, Jonathan Cameron <jic23@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com, eric.miao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > accel/bma150.c
> > An input driver exists for that one. (cc'd Eric)
>
> [Two input drivers - bma023 which I posted covers it too ;)]
>
> > > # sensors - compass
> > > compass/ak8975.c
>
> We have a driver for this (I posted a while back)
>
> > > compass/ak8972.c
>
> > > compass/ami30x.c
>
> AMI304 is identical to the AK8974 which we already have - Gram Hsieh
> posted patches for this a while ago

It seems that some sensors are in input and but that most are in iio.
Obviously I don't want to dissent with both and put ours in misc, so how
do we make this better?  Should we work on cleaning this up.  If so should
we start moving the drivers that are in input to iio.

If this is the right thing to do, I could start working on merging the
current mpu3050 input interface and our misc interface to the iio
interface.  I'm still trying to wrap my head around the iio framework, but
I think one of the things I need is a uinput like interface for iio
(perhaps it exists, I just haven't figured it out yet).  If the DMP is
used, a buffer for the FIFO data would be created, and user space would be
responsible to push the sensor data back to iio after sensor fusion and
calibration.  Without the DMP, each sensor driver would act independently
providing their own raw data.

We still need a way to read and write registers and DMP memory during
runtime from user space.
