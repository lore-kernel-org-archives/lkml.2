Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815Ab2DLVOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:14:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37927 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab2DLVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:14:40 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 0/2] i2c/of: Populate multiplexed i2c busses from the device tree.
Date: Thu, 12 Apr 2012 14:14:21 -0700
Message-Id: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

v3: Integrate changes from Lars-Peter Clausen to make better use of
    the of_*() infrastructure.  Get rid of ugly #ifdefs.

v2: Update bindings to use "reg" insutead of "cell-index"

v1: Unchanged from the original RFC where I said:

  We need to populate our I2C devices from the device tree, but some
  of our systems have multiplexers which currently break this process.

  The basic idea is to have the generic i2c-mux framework propagate
  the device_node for the child bus into the corresponding
  i2c_adapter, and then call of_i2c_register_devices().  This means
  that the device tree bindings for *all* i2c muxes must have some
  common properties.  I try to document these in mux.txt.

This is now tested against 3.4-rc2 and is still working well.

David Daney (2):
  i2c: Add a struct device * parameter to i2c_add_mux_adapter()
  i2c/of: Automatically populate i2c mux busses from device tree data.

 Documentation/devicetree/bindings/i2c/mux.txt |   60 +++++++++++++++++++++++++
 drivers/i2c/i2c-mux.c                         |   43 ++++++++++++++----
 drivers/i2c/muxes/gpio-i2cmux.c               |    3 +-
 drivers/i2c/muxes/pca9541.c                   |    3 +-
 drivers/i2c/muxes/pca954x.c                   |    2 +-
 include/linux/i2c-mux.h                       |    3 +-
 6 files changed, 101 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/mux.txt

Cc: Lars-Peter Clausen <lars@metafoo.de>
-- 
1.7.2.3

