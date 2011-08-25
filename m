Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1HYA0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 20:26:31 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11374 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HYA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 20:26:06 -0400
From: David Daney <david.daney@cavium.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [RFC PATCH 0/2] i2c/of: Populate multiplexed i2c busses from the device tree.
Date: Wed, 24 Aug 2011 17:25:54 -0700
Message-Id: <1314231956-21115-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 25 Aug 2011 00:26:02.0738 (UTC) FILETIME=[9228A520:01CC62BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to populate our I2C devices from the device tree, but some of
our systems have multiplexers which currently break this process.

The basic idea is to have the generic i2c-mux framework propagate the
device_node for the child bus into the corresponding i2c_adapter, and
then call of_i2c_register_devices().  This means that the device tree
bindings for *all* i2c muxes must have some common properties.  I try
to document these in mux.txt.

At this point it is an RFC because the patches are against an old
kernel.  Once we agree on how this should look, I will test them
against a current kernel.

Any feedback on the approach and/or specific bindings is most welcome.

David Daney (2):
  i2c: Add a struct device * parameter to i2c_add_mux_adapter()
  i2c/of: Automatically populate i2c mux busses from device tree data.

 Documentation/devicetree/bindings/i2c/mux.txt |   54 +++++++++++++++++++++++++
 drivers/i2c/i2c-mux.c                         |   44 ++++++++++++++++----
 drivers/i2c/muxes/gpio-i2cmux.c               |    3 +-
 drivers/i2c/muxes/pca9541.c                   |    3 +-
 drivers/i2c/muxes/pca954x.c                   |    2 +-
 include/linux/i2c-mux.h                       |    3 +-
 6 files changed, 96 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/i2c/mux.txt

-- 
1.7.2.3

