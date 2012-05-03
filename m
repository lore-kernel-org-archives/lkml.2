Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2ECHsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:48:03 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:59900 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2ECHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:48:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAFo3ok9bdWOb/2dsb2JhbABEsyOBB4J3EoE+iCS7BJEIBJV+hXaKTIJq
X-IronPort-AV: E=Sophos;i="4.75,522,1330902000"; 
   d="scan'208";a="508220738"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] add support for IndustryPack devices
Date: Thu,  3 May 2012 09:47:44 +0200
Message-Id: <1336031267-10689-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kernel Developers,

The bunch of patches add support for IndustryPack devices as a carrier board
called TEWS TPCI-200 and a mezzanine board called IP-OCTAL, among a virtual bus
driver called ipack.

TPCI-200 is a bridge between PCIe and IndustryPack with 4 slots. IP-OCTAL is a
8 channel serial port device that, depending of the model, can talk RS-232,
RS-422 or RS-485.

The ipack driver is just an abstraction of the bus providing the common
operations between the two aforementioned devices.

These drivers have been tested some time ago in an old kernel version at CERN
(2.6.24) and they are working there. The present ones are just a clean-up of the
original ones to be, hopefully, integrated mainstream.

These drivers have several ugly hacks that I want to fix:

* TPCI-200: it receives the name of the mezzanine plugged in each slot by SYSFS.
  No autodetection supported yet, because the mezzanine driver could not be
  loaded at the time that the tpci200 driver loads.

* IP-OCTAL: it has a linked list which saves the devices it is currently
  managing. It should use the driver_for_each_device() function. It is not there
  due to the impossibility of using container_of macro to recover the
  corresponding "struct ipoctal" because the attribute "struct ipack_device" is
  a pointer. This code should be refactored.

* Ipack: the structures and API exported can be improved a lot. For example, the
  way to unregistering mezzanine devices, doing the mezzanine driver a call to
  remove_device() to notify the carrier driver, or the opposite with the call to
  the ipack_driver_ops' remove() function could be improved.   

The idea is to receive some feedback: comments, suggestions, critics... 
improving the code's quality. Also, public this development to receive new
contributions.

Thanks,

Sam

Samuel Iglesias Gonsalvez (3):
  Staging: IndustryPack bus for the Linux Kernel
  Staging: ipack: added support for the TEWS TPCI-200 carrier board
  Staging: ipack: add support for IP-OCTAL mezzanine board

 drivers/staging/Kconfig                 |    2 +
 drivers/staging/Makefile                |    1 +
 drivers/staging/ipack/Kconfig           |   17 +
 drivers/staging/ipack/Makefile          |    6 +
 drivers/staging/ipack/TODO              |   15 +
 drivers/staging/ipack/bridges/Kconfig   |    7 +
 drivers/staging/ipack/bridges/Makefile  |    1 +
 drivers/staging/ipack/bridges/tpci200.c | 1163 +++++++++++++++++++++++++++++++
 drivers/staging/ipack/bridges/tpci200.h |  165 +++++
 drivers/staging/ipack/devices/Kconfig   |    7 +
 drivers/staging/ipack/devices/Makefile  |    1 +
 drivers/staging/ipack/devices/ipoctal.c |  841 ++++++++++++++++++++++
 drivers/staging/ipack/devices/ipoctal.h |   81 +++
 drivers/staging/ipack/devices/scc2698.h |  229 ++++++
 drivers/staging/ipack/ipack.c           |  179 +++++
 drivers/staging/ipack/ipack.h           |  186 +++++
 16 files changed, 2901 insertions(+)
 create mode 100644 drivers/staging/ipack/Kconfig
 create mode 100644 drivers/staging/ipack/Makefile
 create mode 100644 drivers/staging/ipack/TODO
 create mode 100644 drivers/staging/ipack/bridges/Kconfig
 create mode 100644 drivers/staging/ipack/bridges/Makefile
 create mode 100644 drivers/staging/ipack/bridges/tpci200.c
 create mode 100644 drivers/staging/ipack/bridges/tpci200.h
 create mode 100644 drivers/staging/ipack/devices/Kconfig
 create mode 100644 drivers/staging/ipack/devices/Makefile
 create mode 100644 drivers/staging/ipack/devices/ipoctal.c
 create mode 100644 drivers/staging/ipack/devices/ipoctal.h
 create mode 100644 drivers/staging/ipack/devices/scc2698.h
 create mode 100644 drivers/staging/ipack/ipack.c
 create mode 100644 drivers/staging/ipack/ipack.h

-- 
1.7.10

