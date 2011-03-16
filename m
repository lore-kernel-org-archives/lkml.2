Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CPIdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:33:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35065 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1CPIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:33:31 -0400
Subject: [PATCH v2 0/5] Refactor and enhance device tree platform registrations
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 02:33:28 -0600
Message-ID: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically only the last two patches are v2 patches, the first three are
cleanups written when they were refactored, and this is a first
posting for them.

The most interesting part of this series is the addition of
of_platform_prepare() which is useful to allow DT and non-DT board
support to share the same initialization code for on-chip platform
devices.

---

Grant Likely (5):
      dt: Refactor of_platform_bus_probe()
      dt: protect against NULL matches passed to of_match_node()
      dt: eliminate OF_NO_DEEP_PROBE and test for NULL match table
      dt: add of_platform_populate() for creating device from the device tree
      dt: add of_platform_prepare() to match nodes with static platform_devices


 arch/arm/mach-versatile/core.c               |    1 
 arch/powerpc/platforms/52xx/mpc52xx_common.c |   10 -
 drivers/of/address.c                         |   14 +
 drivers/of/base.c                            |    3 
 drivers/of/platform.c                        |  347 ++++++++++++++++++++++----
 include/linux/of_address.h                   |    1 
 include/linux/of_platform.h                  |    8 -
 7 files changed, 326 insertions(+), 58 deletions(-)

-- 
Signature
