Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2JGNOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:14:21 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:46388 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952Ab2JGNOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:14:14 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>
Subject: [bisected] PS/2 keyboard and mouse dead on resume on Intel D845BG
Date: Sun, 7 Oct 2012 15:13:27 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210071513.27959.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Intel D845BG board comes out of S3 with PS/2 keyboard and mouse completely 
dead. The machine works otherwise (with USB keyboard or over network). When 
rebooted in this state, the BIOS hangs with blank screen. I have the latest 
BIOS installed (P08).

Old kernels worked. Bisection pointed to commit: 
b6dacf63e9fb2e7a1369843d6cef332f76fca6a3
(ACPI: Unconditionally set SCI_EN on resume)

Commenting out this line in drivers/acpi/sleep.c:
	acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
fixes the problem.

Any ideas why this breaks on this system?

-- 
Ondrej Zary
