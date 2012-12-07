Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2LGA2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:28:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51663 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab2LGA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:28:44 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 0/3] ARM: tegra: enable HDMI port on various boards
Date: Thu,  6 Dec 2012 17:28:34 -0700
Message-Id: <1354840117-31264-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

When tegradrm came along, I chose not to allow HDMI ports to be enabled
on boards that had built-in LCDs, since tegradrm had issues when multiple
outputs were enabled, and I wanted to bias towards internal LCDs working
first. However, that bug has now been squashed, so we can now enable HDMI
anywhere it works. In fact, enabling the LCD outputs may be delayed a
while, as we sort out power sequences vs. generic panel drivers vs. ...

Note that if you have a bootloader that turns on the LCD, and the kernel
doesn't have the LCD output enabled (which is always true right now), the
kernel doesn't disable the LCD scanout. I've filed a bug internally for
Mark Zhang to look into this. However, the HDMI output should still work
fine; the LCD will just display various odd things.

In theory, we could enable HDMI on Cardhu, but I haven't in this series
because doing so causes memory fetch underflow (at least for some external
display resolutions) (since the LCD is enabled too, and not turned off)
since we aren't programming the memory controller correctly yet. As such,
HDMI doesn't actually work well on Cardhu yet.

Stephen Warren (3):
  ARM: tegra: seaboard: enable HDMI port
  ARM: tegra: ventana: enable HDMI port
  ARM: tegra: paz00: enable HDMI port

 arch/arm/boot/dts/tegra20-paz00.dts    |   18 +++++++++++++++---
 arch/arm/boot/dts/tegra20-seaboard.dts |   18 +++++++++++++++---
 arch/arm/boot/dts/tegra20-ventana.dts  |   18 +++++++++++++++---
 3 files changed, 45 insertions(+), 9 deletions(-)

-- 
1.7.10.4

