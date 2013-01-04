Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3ADTbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:31:24 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37542 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060Ab3ADTbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:31:19 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/6] Introducing Device Tree Overlays
Date: Fri,  4 Jan 2013 21:31:04 +0200
Message-Id: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset introduces Device Tree overlays, a method
of dynamically altering the kernel's live Device Tree.

This patchset is against mainline as of Friday Jan 4 2013.
(4956964 Merge tag 'driver-core-3.8-rc2' of \
 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)

Note that a separate patch for the DTC compiler has been posted and
is required to compile the DTS files according to the documentation.
The patch is "dtc: Dynamic symbols & fixup support"

An implementation patchset for a beaglebone cape loader will follow,
but if you want to check out a working kernel for the beaglebone please
pull from:

git://github.com/pantoniou/linux-bbxm.git branch not-capebus-v8

Pantelis Antoniou (6):
  OF: Introduce device tree node flag helpers.
  OF: export of_property_notify
  OF: Export all DT proc update functions
  OF: Introduce utility helper functions
  OF: Introduce Device Tree resolve support.
  OF: Introduce DT overlay support.

 .../devicetree/dynamic-resolution-notes.txt        |  25 +
 Documentation/devicetree/overlay-notes.txt         | 179 +++++
 drivers/of/Kconfig                                 |  19 +
 drivers/of/Makefile                                |   4 +-
 drivers/of/base.c                                  | 114 +--
 drivers/of/overlay.c                               | 831 +++++++++++++++++++++
 drivers/of/resolver.c                              | 394 ++++++++++
 drivers/of/util.c                                  | 253 +++++++
 include/linux/of.h                                 | 243 ++++++
 9 files changed, 2005 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/overlay.c
 create mode 100644 drivers/of/resolver.c
 create mode 100644 drivers/of/util.c

-- 
1.7.12

