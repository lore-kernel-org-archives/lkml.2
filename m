Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860Ab2C3KU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:20:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38498 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab2C3KUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:20:33 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv3 0/6] spi: omap2-mcspi: driver updates
Date: Fri, 30 Mar 2012 15:50:16 +0530
Message-ID: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series does the following cleanups
- Converts the spi to module_platform_driver
- Use the devm functions so that the freeing need not 
  be done in the driver.
- Makes the driver use autosuspend
- Folds Benoit's bus_num removal patch in the series

Changes from v1
- Makes the driver use autosuspend
- Folds Benoit's bus_num removal patch in the series

Changes from v2
- The tmp variable is used to write this can be optimised 
 as it is not needed if the value is directly written.
 Acknowledge  Tarun for the suggestion.

This is also available through
git     : git://gitorious.org/linus-tree/linus-tree.git
branch  : spi

This is targeted for v3.5. 

Benoit Cousson (1):
  spi/omap: Remove bus_num usage for instance index

Felipe Balbi (2):
  spi: omap2-mcspi: make it behave as a module
  spi: omap2-mcspi: convert to module_platform_driver

Shubhrajyoti D (3):
  spi: omap2-mcspi: use devm_* functions
  spi: omap2-mcspi: add support for pm_runtime autosuspend
  spi: omap2-mcspi: Trivial optimisation

 drivers/spi/spi-omap2-mcspi.c |  132 +++++++++++++++-------------------------
 1 files changed, 50 insertions(+), 82 deletions(-)

