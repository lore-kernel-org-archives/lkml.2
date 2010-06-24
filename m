Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0FXULu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 16:11:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47101 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0FXULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 16:11:48 -0400
Subject: [PATCH 0/3] Automatically register i2c devices from the device tree
To: devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, wg@denx.de
Date: Thu, 24 Jun 2010 14:11:44 -0600
Message-ID: <20100624200509.10527.513.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds automatic registration of i2c devices from
OF device tree data.  If the i2c bus has the of_node pointer set, then
it will use that node pointer as the parent for a set of i2c devices and
automatically register the child nodes as new i2c devices.

When CONFIG_OF is not set, the of i2c hooks become empty stubs.

---

Grant Likely (3):
      of/i2c: Generalize OF support
      i2c: Add OF-style registration and binding
      of: refactor of_modalias_node() and remove explicit match table.


 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |    6 ++
 drivers/i2c/busses/i2c-cpm.c                   |    6 --
 drivers/i2c/busses/i2c-ibm_iic.c               |    4 --
 drivers/i2c/busses/i2c-mpc.c                   |    2 -
 drivers/i2c/i2c-core.c                         |    9 +++
 drivers/mmc/host/mmc_spi.c                     |    8 +++
 drivers/of/Kconfig                             |    2 -
 drivers/of/base.c                              |   64 +++---------------------
 drivers/of/of_i2c.c                            |   50 +++++++++++--------
 include/linux/of_i2c.h                         |   13 ++++-
 10 files changed, 75 insertions(+), 89 deletions(-)
