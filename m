Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0JNQT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:19:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0JNQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:19:57 -0400
Subject: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
To: spi-devel-general@lists.sourceforge.net, richard.rojfors@mocean-labs.com,
        john.linn@xilinx.com, monstr@monstr.eu
From: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 14 Oct 2010 10:19:54 -0600
Message-ID: <20101014161724.18966.42340.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since of_platform_bus_type has been merged with the platform_bus_type,
a single platform driver can now support both use cases.  This patch
series merges the two halves of the xilinx_spi device driver.

Compile tested only.  I haven't booted this yet.

---

Grant Likely (3):
      spi/xilinx: Eliminate pdata references from common code.
      spi/xilinx: fold platform_driver support into main body
      spi/xilinx: merge OF support code into main driver


 drivers/spi/Kconfig            |   14 ----
 drivers/spi/Makefile           |    2 -
 drivers/spi/xilinx_spi.c       |  133 ++++++++++++++++++++++++++++++++++------
 drivers/spi/xilinx_spi.h       |   32 ----------
 drivers/spi/xilinx_spi_of.c    |  133 ----------------------------------------
 drivers/spi/xilinx_spi_pltfm.c |  102 -------------------------------
 6 files changed, 114 insertions(+), 302 deletions(-)
 delete mode 100644 drivers/spi/xilinx_spi.h
 delete mode 100644 drivers/spi/xilinx_spi_of.c
 delete mode 100644 drivers/spi/xilinx_spi_pltfm.c

