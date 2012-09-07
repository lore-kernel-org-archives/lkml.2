Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab2IGH3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:29:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:49727 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2IGH32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="142497559"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 00/12] ACPI: add module_acpi_driver() and convert drivers to it
Date: Fri,  7 Sep 2012 10:31:37 +0300
Message-Id: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending the series with acks]

This is similar than what is done for other busses before (PCI, I2C, SPI,
platform). It reduces a lot of unnecessary boilerplate code from modules.

We also remove following redundant check on few drivers:

	if (acpi_disabled)
		return -ENODEV;

as this same check is already done at the beginning of
acpi_bus_register_driver().

I think these should all go via ACPI tree because they all depend on the
first patch which touches the ACPI subsystem.

Mika Westerberg (12):
  ACPI: introduce module_acpi_driver() helper macro
  ACPI/button: convert to module_acpi_driver()
  ACPI/fan: convert to module_acpi_driver()
  ACPI/hed: convert to module_acpi_driver()
  ACPI/sbshc: convert to module_acpi_driver()
  i2c-scmi: convert to module_acpi_driver()
  Input: atlas_btns - convert to module_acpi_driver()
  hp_accel: convert to module_acpi_driver()
  ideapad: convert to module_acpi_driver()
  topstar-laptop: convert to module_acpi_driver()
  toshiba_bluetooth: convert to module_acpi_driver()
  xo15-ebook: convert to module_acpi_driver()

 drivers/acpi/button.c                    |   13 +------------
 drivers/acpi/fan.c                       |   22 +---------------------
 drivers/acpi/hed.c                       |   20 +-------------------
 drivers/acpi/sbshc.c                     |   18 +-----------------
 drivers/i2c/busses/i2c-scmi.c            |   14 +-------------
 drivers/input/misc/atlas_btns.c          |   17 +----------------
 drivers/platform/x86/hp_accel.c          |   25 +------------------------
 drivers/platform/x86/ideapad-laptop.c    |   14 +-------------
 drivers/platform/x86/topstar-laptop.c    |   22 +---------------------
 drivers/platform/x86/toshiba_bluetooth.c |   22 +---------------------
 drivers/platform/x86/xo15-ebook.c        |   14 +-------------
 include/acpi/acpi_bus.h                  |   13 +++++++++++++
 12 files changed, 24 insertions(+), 190 deletions(-)

-- 
1.7.10.4

