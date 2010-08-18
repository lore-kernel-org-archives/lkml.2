Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0HRIgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:36:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50071 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0HRIgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:36:13 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera power
Date: Wed, 18 Aug 2010 16:36:04 +0800
Message-Id: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are made against 2.6.36-rc1 and also available at
  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git for-upstream

Once the rfkill of a laptop is set to block, it is no way to unblock with Linux
without driver. Thanks for David Woodhouse wrote the first driver solving this.

But the \_SB_.GECN and \_SB_.DECN are only available on Lenovo ideapad S10-3.
Using EC command to control rf/camera power is better because I believe every
ideapads which has VPC2004 device in its DSDT has this common method.

This driver is tested and work fine on Lenovo ideapad B550 and ideapad S10-3.

Ike Panhc (8):
  ideapad: add ACPI helpers
  ideapad: check VPC bit before sync rfkill hw status
  ideapad: make sure we bind on the correct device
  ideapad: use return value of _CFG to tell if device exist or not
  ideapad: use EC command to control camera
  ideapad: rewrite the hw rfkill notify
  ideapad: rewrite the sw rfkill set
  ideapad: Change the driver name to ideapad_laptop

 drivers/platform/x86/Kconfig          |    4 +-
 drivers/platform/x86/Makefile         |    2 +-
 drivers/platform/x86/ideapad_acpi.c   |  306 --------------------------
 drivers/platform/x86/ideapad_laptop.c |  381 +++++++++++++++++++++++++++++++++
 4 files changed, 384 insertions(+), 309 deletions(-)
 delete mode 100644 drivers/platform/x86/ideapad_acpi.c
 create mode 100644 drivers/platform/x86/ideapad_laptop.c

