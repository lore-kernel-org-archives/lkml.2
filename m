Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2FMKW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:22:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6060 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2FMKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 13 Jun 2012 03:21:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <khali@linux-fr.org>, <w.sang@pengutronix.de>, <ben-linux@fluff.org>,
        <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v3 0/4]  i2c: tegra: Bug fixes, cleanups and M_NOSTART support
Date: Wed, 13 Jun 2012 15:42:35 +0530
Message-ID: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series having the:
- Handling of late register write due to Tegra PPSB design.
- support for I2C_M_NOSTART
- Use devm_* for all allocation.

Changes from V1:
- Using the readback for mask/unmask of irq also.

Changes from V2:
- Read back is done whenever write happen in i2c register other than TX FIFO.


Laxman Dewangan (4):
  i2c: tegra: make sure register writes completes
  i2c: tegra: add PROTOCOL_MANGLING as supported functionality.
  i2c: tegra: support for I2C_M_NOSTART functionality
  i2c: tegra: make all resource allocation through devm_*

 drivers/i2c/busses/i2c-tegra.c |  110 ++++++++++++++++++++++------------------
 1 files changed, 60 insertions(+), 50 deletions(-)

