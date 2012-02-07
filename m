Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2BGIeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:34:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41426 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2BGIeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:34:24 -0500
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Gross <markgross@thegnar.org>,
        Venkatesh Pallipadi <venki@google.com>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 0/2] PM / QoS: unconditionally build the feature
Date: Tue,  7 Feb 2012 09:34:04 +0100
Message-Id: <1328603646-2714-1-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM QoS features depend on CONFIG_PM which depends on
PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
not having these CONFIGs.
    
Those patches allow the features in all cases.

Based on 3.3-rc1 from mainline.
Tested on OMAP3 Beagleboard, with CONFIG_PM.
Compile tested using the i386 defconfig, with and without CONFIG_PM.


Jean Pihet (2):
  PM / QoS: unconditionally build the feature
  PM / QoS: unconditionally build the per-device constraints feature

 drivers/base/power/Makefile |    3 +-
 include/linux/pm_qos.h      |   66 -------------------------------------------
 kernel/power/Makefile       |    3 +-
 3 files changed, 4 insertions(+), 68 deletions(-)

-- 
1.7.5.4

