Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1KYO5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 09:57:17 -0500
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:54726 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468Ab1KYO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 09:57:15 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 0/2] MFD: twl6040-codec: avoid reconfiguring the PLL
Date: Fri, 25 Nov 2011 16:57:05 +0200
Message-Id: <1322233027-23515-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
1.7.8.rc3

