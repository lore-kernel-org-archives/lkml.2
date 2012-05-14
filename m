Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2ENKxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:04 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:56977 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755303Ab2ENKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:02 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 06:52:58 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAB3hsE9bdWOb/2dsb2JhbABEs3CBB4MDCweBPoglB7ovkSIElX2BEY8vgms
X-IronPort-AV: E=Sophos;i="4.75,585,1330902000"; 
   d="scan'208";a="990372068"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Staging ipack: device model and clean-up
Date: Mon, 14 May 2012 12:41:24 +0200
Message-Id: <1336992089-2733-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These patches introduce some clean-up code and fix one bug related to the
presence of ipack_driver ops.

The big change is added by [PATCH 2/5] where it adds a better support to device
model in the ipack driver.

All the devices (carrier and mezzanine boards) are ipack_devices and it is
needed to make a relation between an ipack_device and an ipack_driver using
the provided match/probe functions.

Doing that, it is possible to represent the relation between each carrier and
mezzanines plugged to it through sysfs and, also, between each device and its
driver.

These patches apply on top of the previous ones:

http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/02410.html

Thanks,

Sam

Samuel Iglesias Gonsalvez (5):
  Staging ipack: fix a few sparse warnings
  Staging: ipack: add proper device model into ipack_bus_register.
  Staging: ipack: remove board_name and bus_name fields from struct
    ipack_device
  Staging ipack/bridges/tpci200: remove TPCI200_SHORTNAME constant
  Staging: ipack/devices/ipoctal: check for availability of helper
    functions in ipoctal_match()

 drivers/staging/ipack/bridges/tpci200.c |  225 ++++++++++++++++---------------
 drivers/staging/ipack/bridges/tpci200.h |   18 ++-
 drivers/staging/ipack/devices/ipoctal.c |   12 +-
 drivers/staging/ipack/ipack.c           |   68 ++++++++--
 drivers/staging/ipack/ipack.h           |   61 ++++-----
 5 files changed, 220 insertions(+), 164 deletions(-)

-- 
1.7.10

