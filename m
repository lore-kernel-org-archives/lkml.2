Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967427Ab2EPLMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:12:10 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:51131 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967293Ab2EPLMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:12:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        peter.ujfalusi@ti.com, Misael Lopez Cruz <misael.lopez@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH v3 0/4] MFD: twl6040: Device tree support
Date: Wed, 16 May 2012 14:11:54 +0300
Message-Id: <1337166718-8458-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes since v2:
- Child devices are no longer described in dts, they are created with
  mfd_add_devices()
- ASoC codec device is created unconditionally (main function of twl6040)

Changes since v1:
- Commit message for patch 2 (Allocate IRQ numbers dynamically) has been updated
  to describe that the twl6040 can not be used as IRQ extender type of device.

Commit message from v1:

The following series adds device tree support for the twl6040 MFD core driver.
Support for the child drivers (vibra, ASoC codec) will be submitted via the
corresponding subsystem since there is no compile time dependency between them.

The first patch is a minor clean up patch to remove wrapped lines in the
twl6040-irq.c. The resulting code is more natural to read to me.

The series depends on the regulator support patch for the twl6040:
http://marc.info/?l=linux-kernel&m=133596703610515&w=2

Regards,
Peter
---
Peter Ujfalusi (4):
  MFD: twl6040: Code cleanup in interrupt initialization part
  MFD: twl6040: Allocate IRQ numbers dynamically
  MFD: twl6040: Register the child for the ASoC codec unconditionally
  MFD: twl6040: Add support for Device Tree

 Documentation/devicetree/bindings/mfd/twl6040.txt |   62 ++++++++++++++++++
 drivers/mfd/twl6040-core.c                        |   69 ++++++++++++---------
 drivers/mfd/twl6040-irq.c                         |   32 +++++++---
 3 files changed, 124 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl6040.txt

-- 
1.7.8.6

