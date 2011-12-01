Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1LAXrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:47:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:33231 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab1LAXrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:47:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: gregkh@suse.de, alan@linux.intel.com, galak@kernel.crashing.org,
        scottwood@freescale.com
Cc: linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] RFC Fix Fsl 8250 BRK bug via letting plat code set bugs
Date: Thu,  1 Dec 2011 18:47:35 -0500
Message-Id: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of an earlier patch[1] that enabled a workaround
via Kconfig for an errata issue when using BRK on FSL 16550 UARTs.

In this version, the 8250 specific bug field is moved to the generic
uart_port struct, since hardware bugs aren't the unique domain of 
just the 8250 class of uarts.

Then the ability to set a known bugs value via the platform_device entry
point is added, so that it can be set externally vs. requiring some sort
of autodetection from the actual driver(s).

Then, the FSL errata fix is added to 8250.c by using the above support.
An entry in a DTS file is used to flag boards/platforms with the issue.
It is also added in a way that is optimized away for other architectures.

Kumar has a patch pending[2] that updates all the dts files.  I've not
included it here, so that review focus can be on the implementation.

I've re-tested it on an sbc8641D, where sysrq was useless before; with
this fix, it works as expected.

Thanks,
Paul.

[1] http://patchwork.ozlabs.org/patch/46609/
[2] http://patchwork.ozlabs.org/patch/128070/

--------

Paul Gortmaker (3):
  serial: make bugs field not specific to 8250 type uarts.
  serial: allow passing in hardware bug info via platform device
  8250: add workaround for MPC8[356]xx UART break IRQ storm

 arch/powerpc/kernel/legacy_serial.c |   11 ++++++++++
 drivers/tty/serial/8250.c           |   37 +++++++++++++++++++++-------------
 drivers/tty/serial/8250.h           |    5 ----
 include/linux/serial_8250.h         |   11 ++++++++++
 include/linux/serial_core.h         |    1 +
 5 files changed, 46 insertions(+), 19 deletions(-)

-- 
1.7.7

