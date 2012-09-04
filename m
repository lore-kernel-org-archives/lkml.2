Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2IDPKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:10:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34934 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757018Ab2IDPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:17 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2012 11:10:17 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4JKDwE0EjUCJgJfiCSne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821812"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 00/16] ipack: autoload IP module drivers
Date: Tue,  4 Sep 2012 17:01:05 +0200
Message-Id: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This bunch of patches adds support to autoload IP module drivers when they are
detected by the ipack bus driver.

Also, it changes the endianness of the carrier device to Big Endian as it is
defined in the Industry Pack standard. Due to that, the source code is
simplified too.

There are more patches (~40) waiting to be sent but I prefer to send them in
batches for proper review. If you think it will be a better idea to send them
all together, please tell me.

Thanks to Jens Taprogge for his work on this area.

Best regards,

Sam

Jens Taprogge (15):
  Staging: ipack/bridges/tpci200: Reorganize tpci200_probe in
    preparation for functional changes.
  Staging: ipack/bridges/tpci200: Use the TPCI200 in big endian mode.
  Staging: ipack/devices/ipoctal: Convert ipoctal to directly use
    ioread/write functions.
  Staging: ipack/bridges/tpci200: Remove the read/write functions from
    ipack_bus_ops.
  Staging: ipack/devices/ipoctal: ipoctal cleanups.
  Staging: ipack/devices/ipoctal: Tidy up ipoctal some more.
  Staging: ipack: implement ipack device table.
  Staging: ipack: Read the ID space during device registration.
  Staging: ipack: Parse vendor and device id.
  Staging: ipack: Move device ids from ipoctal.c to ipack_ids.h.
  Staging: ipack: Make ipack_driver_ops const.
  Staging: ipack/devices/ipoctal: Expose DEVICE_TABLE for ipoctal.
  Staging: ipack: Implement device matching on the bus level.
  Staging: ipack: Expose modalias through sysfs.
  Staging: ipack: Provide ID Prom through sysfs.

Samuel Iglesias Gonsálvez (1):
  Staging: ipack: remove read/write operations from ipack_bus_ops

 drivers/staging/ipack/bridges/tpci200.c |  280 ++++++-------------------------
 drivers/staging/ipack/bridges/tpci200.h |    9 +
 drivers/staging/ipack/devices/ipoctal.c |  188 +++++++++------------
 drivers/staging/ipack/devices/scc2698.h |  114 ++++++-------
 drivers/staging/ipack/ipack.c           |  271 ++++++++++++++++++++++++++++--
 drivers/staging/ipack/ipack.h           |   49 ++++--
 drivers/staging/ipack/ipack_ids.h       |   32 ++++
 include/linux/mod_devicetable.h         |    7 +
 scripts/mod/file2alias.c                |   15 ++
 9 files changed, 543 insertions(+), 422 deletions(-)
 create mode 100644 drivers/staging/ipack/ipack_ids.h

-- 
1.7.10.4

