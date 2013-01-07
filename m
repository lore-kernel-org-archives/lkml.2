Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab3AGSvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:51:19 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58294 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754805Ab3AGSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:51:17 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/5] DT Overlay based cape manager for TI's Beaglebone
Date: Mon,  7 Jan 2013 20:51:01 +0200
Message-Id: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing a Device Tree overlay cape manager.

Using it it is possible to support the growing cape ecosystem for
the beaglebone, without having to hack a board file for each and
every cape plug combination.

It is possible to force load capes, and also possible to remove
them if need be (although precious few drivers support removal).

This patch is against the mainline kernel as of Jan 7 2013, top
of the tree: "5f243b9 Merge tag 'arm64-fixes' of \
	git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch640"

You will need to have the DTC compiler patch which was posted seperately
to the DTC mailing list "dtc: Dynamic symbols & fixup support", as well
as the I2C accessor patch "i2c-EEPROM: In kernel memory accessor interface" I
posted earlier.

Note that not many interesting capes are supported in the mainline kernel,
since the drivers some time to land in mainline, but you can see an
example of a (almost) feature complete linux kernel at:

git://github.com/pantoniou/linux-bbxm.git branch not-capebus-v9


Pantelis Antoniou (5):
  capemgr: Beaglebone DT overlay based cape manager
  capemgr: Add beaglebone's cape driver bindings
  capemgr: am335x-bone capemgr bindings
  capemgr: firmware makefiles for DT objects
  capemgr: Weather cape cape definition

 .../devicetree/bindings/misc/capes-beaglebone.txt  |  110 ++
 arch/arm/boot/dts/am335x-bone.dts                  |   75 +-
 arch/arm/mach-omap2/Kconfig                        |    2 +
 drivers/misc/Kconfig                               |    2 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/cape/Kconfig                          |    5 +
 drivers/misc/cape/Makefile                         |    5 +
 drivers/misc/cape/beaglebone/Kconfig               |   11 +
 drivers/misc/cape/beaglebone/Makefile              |    5 +
 drivers/misc/cape/beaglebone/capemgr.c             | 1835 ++++++++++++++++++++
 firmware/Makefile                                  |   12 +
 firmware/capes/cape-bone-weather-00A0.dts          |   66 +
 12 files changed, 2128 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/misc/capes-beaglebone.txt
 create mode 100644 drivers/misc/cape/Kconfig
 create mode 100644 drivers/misc/cape/Makefile
 create mode 100644 drivers/misc/cape/beaglebone/Kconfig
 create mode 100644 drivers/misc/cape/beaglebone/Makefile
 create mode 100644 drivers/misc/cape/beaglebone/capemgr.c
 create mode 100644 firmware/capes/cape-bone-weather-00A0.dts

-- 
1.7.12

