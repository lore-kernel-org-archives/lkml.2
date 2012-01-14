Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2ANT65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 14:58:57 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:46114 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756555Ab2ANT64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 14:58:56 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND 0/2] MFD: twl6040-codec: avoid reconfiguring the PLL
Date: Sat, 14 Jan 2012 20:58:42 +0100
Message-Id: <1326571124-11436-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Samual,

This series somehow got lost (the original series has been sent back in
November).
It might be too late for 3.3 :(

The following two patch will optimize the PLL configuration code for the
twl6040, so if the requested configuration is the same as the current we simply
skip configuring the PLL (since no change needed).
We can save considerable amount of time in this way (due to avoiding i2c
accesses, and delays dictated by the configuration protocol).

Regards,
Peter
---
Peter Ujfalusi (2):
  MFD: twl6040-codec: Store mclk configuration
  MFD: twl6040-codec: Avoid PLL reconfiguration when not needed

 drivers/mfd/twl6040-core.c  |  128 ++++++++++++++++++++++++++-----------------
 include/linux/mfd/twl6040.h |    2 +
 2 files changed, 79 insertions(+), 51 deletions(-)

-- 
1.7.8.3

