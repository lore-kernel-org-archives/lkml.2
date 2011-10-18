Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab1JRPad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:30:33 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:41292 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab1JRP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:29:41 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/6] IIO in kernel interfaces.
Date: Tue, 18 Oct 2011 16:29:30 +0100
Message-Id: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are obviously some rough corners in here that will need cleaning up.
For now I've just put this out there to see if anyone radically disagrees
on the direction.  It sits on top the recent rfc to move first bit of IIO
out of staging with a few buglets fixed.  Best bet if anyone wants to
test is to pull from:

https://github.com/jic23/linux-iio/tree/outofstaging

which now also includes these patches.

Intereresting patches are 3 and 4.  5 gives a trivial example of
a driver using this (hwmon driver that only takes first matching channel
and sticks it out as in1_input - breaks all sorts elements of the hwmon
interface spec.)

For now I've gone with Mark Brown's suggestion of a datasheet_name for
finding the channels on the device.  Patch 2 hacks this name into the
max1363 driver.  I'll probably put a version matching on channel number and
type in at a later date.

Here we just have a pull interface.  Push is considerably harder to do
and needs quite a lot more of the IIO infrastructure to be in place
(triggers / buffers etc). Events obviously require IIO event handling
to be there. Hence all of that will have to wait until those elements
have in of themselves been posted for review.

It is pretty clear to me that hwmon interface for starters needs the
ability to say - 'give me all mappings that correspond to me'.

This is what I intend to add next followed by some utility functions
to make it easy to match the hwmon interface.

At that point I'll propose the hwmon driver goes into drivers/hwmon
(subject to the underlying iio stuff merging).

Fun fun fun.  Thanks to Linus an Mark for their input on this.
Hope this is roughly what you guys were looking for.

Also on my list to do is to check this very thoroughly for any
possible race conditions around the removal of the underlying
device.

Jonathan

Jonathan Cameron (6):
  IIO: core: add datasheet_name to chan_spec
  IIO:ADC:max1363 add datasheet_name entries.
  IIO:CORE add global list of registered IIO devices.
  IIO:Core add in kernel interface mapping and getting IIO channels.
  IIO:Temporary example hwmon interface.
  stargate2: example of map configuration for iio to hwmon example.

 arch/arm/mach-pxa/stargate2.c  |   23 ++++++++
 drivers/Makefile               |    2 +-
 drivers/iio/Kconfig            |    7 ++
 drivers/iio/Makefile           |    2 +
 drivers/iio/adc/max1363_core.c |    4 +-
 drivers/iio/iio.c              |  121 ++++++++++++++++++++++++++++++++++++++++
 drivers/iio/iio_hwmon.c        |  104 ++++++++++++++++++++++++++++++++++
 drivers/iio/inkern.c           |   21 +++++++
 include/linux/iio/iio.h        |    9 +++-
 include/linux/iio/inkern.h     |   63 +++++++++++++++++++++
 10 files changed, 353 insertions(+), 3 deletions(-)
 create mode 100644 drivers/iio/iio_hwmon.c
 create mode 100644 drivers/iio/inkern.c
 create mode 100644 include/linux/iio/inkern.h

-- 
1.7.7

