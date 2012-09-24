Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2IXQ4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:56:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35520 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2IXQ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:56:37 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, manoj.iyer@canonical.com
Subject: [PATCH 0/1] thinkpad-acpi: enable loading module with new B-series Lenovo BIOS
Date: Mon, 24 Sep 2012 11:56:28 -0500
Message-Id: <1348505788-4090-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

The new B series BIOS has version string 43CN46WW. The driver
requires that 2nd and 3rd characters be 'E' and 'T' respectively,
where as the newer BIOS has 'C' and 'N' respectively. Failing to
load the module causes some of the hotkeys to not work.

This was tested by me on Lenovo B470e and on B570e by James Ferguson

Before the patch
================
sudo modprobe thinkpad_acpi
FATAL: Error inserting thinkpad_acpi (/lib/modules/3.5.0-15-generic/kernel/drivers/platform/x86/thinkpad_acpi.ko): No such device

After the patch
===============
[44937.265438] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[44937.265445] thinkpad_acpi: http://ibm-acpi.sf.net/
[44937.265449] thinkpad_acpi: ThinkPad BIOS 43CN46WW, EC unknown
[44937.265453] thinkpad_acpi: Lenovo Lenovo B470e, model HuronRiver Platform
[44937.266479] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[44937.266557] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[44937.267846] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[44937.268131] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input17

Manoj Iyer (1):
  thinkpad-acpi: enable loading module with new B-series Lenovo BIOS

 drivers/platform/x86/thinkpad_acpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

-- 
1.7.9.5

