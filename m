Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1I0XQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:16:46 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15900 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1I0XQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:16:45 -0400
From: David Daney <david.daney@cavium.com>
To: khali@linux-fr.org, ben-linux@fluff.org, peter.korsgaard@barco.com,
        guenter.roeck@ericsson.com, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/2] i2c/of: Populate multiplexed i2c busses from the device tree.
Date: Tue, 27 Sep 2011 16:16:22 -0700
Message-Id: <1317165384-20390-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 27 Sep 2011 23:16:45.0096 (UTC) FILETIME=[860E5280:01CC7D6B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Update bindings to use "reg" insutead of "cell-index"

v1:
Unchanged from the original RFC where I said:

  We need to populate our I2C devices from the device tree, but some
  of our systems have multiplexers which currently break this process.

  The basic idea is to have the generic i2c-mux framework propagate
  the device_node for the child bus into the corresponding
  i2c_adapter, and then call of_i2c_register_devices().  This means
  that the device tree bindings for *all* i2c muxes must have some
  common properties.  I try to document these in mux.txt.

This is now tested against 3.1.0-rc6 and seems to be working well.

David Daney (2):
  i2c: Add a struct device * parameter to i2c_add_mux_adapter()
  i2c/of: Automatically populate i2c mux busses from device tree data.

 Documentation/devicetree/bindings/i2c/mux.txt |   60 +++++++++++++++++++++++++
 drivers/i2c/i2c-mux.c                         |   44 ++++++++++++++----
 drivers/i2c/muxes/gpio-i2cmux.c               |    3 +-
 drivers/i2c/muxes/pca9541.c                   |    3 +-
 drivers/i2c/muxes/pca954x.c                   |    2 +-
 include/linux/i2c-mux.h                       |    3 +-
 6 files changed, 102 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/mux.txt

-- 
1.7.2.3

