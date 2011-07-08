Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1GHIyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:25 -0400
Received: from service87.mimecast.com ([94.185.240.25]:49985 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754437Ab1GHIyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:21 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC PATCH v2 0/4] Core device subsystem
Date: Fri,  8 Jul 2011 09:54:06 +0100
Message-Id: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 08 Jul 2011 08:54:15.0522 (UTC) FILETIME=[9D723C20:01CC3D4C]
X-MC-Unique: 111070809541901601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p688sXTq032435

There is a small number of devices that the core kernel needs very
early in the boot process, namely an interrupt controller and a timer,
long before the driver model is up and running.

Most architectures implement this requirement by hardcoding the
initialisation of a "well known" piece of hardware which is standard
enough to work on any platform.

This is very different on the ARM architecture, where platforms have a
variety of interrupt controllers and timers. While the same hardcoding
is possible (and is actually used), it makes it almost impossible to
support several platforms in the same kernel.

Though the device tree is helping greatly to solve this problem, some
platform won't ever be converted to DT, hence the need to have a
mechanism supporting a variety of information source. Early platform
devices having been deemed unsuitable (complexity, abuse of various
subsystems), this subsystem has been designed to provide the very
minimal level of functionality.

The "core device subsystem" offers a class based device/driver
matching model, doesn't rely on any other subsystem, is very (too?)
simple, and support getting information both from DT as well as from
static data provided by the platform. It also gives the opportunity to
define the probing order by offering a sorting hook at run-time.

As for the Linux driver model, the core device subsystem deals mainly
with device and driver objects. It also has the notion of "class" to
designate a group of devices implementing the same functionality, and
a group of drivers to be matched against the above devices
(CORE_DEV_CLASS_TIMER for example).

Tested on RealView PB-11MP (with both dt and non dt setups), and
Samsug SMDKv310 (non-dt only).

>From v1 (never posted):
- Interrupt controller sort function
- Bug fixes
- Added documentation

Marc Zyngier (4):
  dt: expose device resource allocator
  Core device subsystem implementation
  Core devices: add OF interrupt controller sorting method
  Core devices: documentation

 Documentation/core_devices.txt    |  247 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S     |    1 +
 drivers/base/Makefile             |    3 +-
 drivers/base/core_device.c        |  217 ++++++++++++++++++++++++++++++++
 drivers/of/platform.c             |   60 ++++++---
 include/asm-generic/vmlinux.lds.h |    6 +
 include/linux/core_device.h       |   71 +++++++++++
 include/linux/of_platform.h       |    2 +
 8 files changed, 587 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/core_devices.txt
 create mode 100644 drivers/base/core_device.c
 create mode 100644 include/linux/core_device.h


