Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0JAHhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:37:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36145 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0JAHhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:37:48 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [Resend] [PATCH 0/9] ideapad: using EC command to control rf/camera power
Date: Fri,  1 Oct 2010 15:37:40 +0800
Message-Id: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are made against current mainline kernel and also available at
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git for-upstream

Once the rfkill of a laptop is set to block, it is no way to unblock with Linux
without driver. Thanks for David Woodhouse wrote the first driver solving this.

But the \_SB_.GECN and \_SB_.DECN are only available on Lenovo ideapad S10-3.
Using EC command to control rf/camera power is better because I believe every
ideapads which has VPC2004 device in its DSDT has this common method.

This driver is tested on Lenovo ideapad B550 and ideapad S10-3 and also tested
by Mario 'BitKoenig' Holbe on Lenovo ideapad S12-VIA.

Changes after last posted:
 * Add schedule() to yield processor when waiting EC.
 * Using time_before() to check timeout.
 * Maximun waiting for EC execution increasing to 100ms in case that we have a
   slow EC.
 * Add parameter: no_bt_rfkill for not setup bluetooth rfkill.

Next step for this driver:
 * Hotkey enablement.

Ike Panhc (9):
  ideapad: add ACPI helpers
  ideapad: check VPC bit before sync rfkill hw status
  ideapad: make sure we bind on the correct device
  ideapad: use return value of _CFG to tell if device exist or not
  ideapad: use EC command to control camera
  ideapad: rewrite the hw rfkill notify
  ideapad: rewrite the sw rfkill set
  ideapad: Change the driver name to ideapad-laptop
  ideapad: Add param: no_bt_rfkill

 drivers/platform/x86/Kconfig          |    4 +-
 drivers/platform/x86/Makefile         |    2 +-
 drivers/platform/x86/ideapad-laptop.c |  394 +++++++++++++++++++++++++++++++++
 drivers/platform/x86/ideapad_acpi.c   |  306 -------------------------
 4 files changed, 397 insertions(+), 309 deletions(-)
 create mode 100644 drivers/platform/x86/ideapad-laptop.c
 delete mode 100644 drivers/platform/x86/ideapad_acpi.c

