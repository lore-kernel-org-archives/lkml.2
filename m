Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031330Ab2I1TcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:32:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38552 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620Ab2I1TcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:32:19 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 0/2] dtc: enable use of pre-processor
Date: Fri, 28 Sep 2012 13:32:09 -0600
Message-Id: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This series adds some build rules to run cpp on *.dtsp prior to
invoking dtc, and converts Tegra to the new rule as an example. What do
people think?

I assume that you've applied the dtc patches I sent yesterday. They
aren't in this series. See:

https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-September/020182.html
https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-September/020183.html
https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-September/020181.html
https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-September/020387.html

Note: those patches are against upstream dtc. If you wish to test this
series, apply the dtc patches to upstream dtc, build it, and copy the
resultant dtc binary over the top of scripts/dtc/dtc.

I'll post a patch to update the in-kernel dtc to the upstream dtc as
soon as one final dtc patch has been applied, and this series will then
depend on that patch.

Stephen Warren (2):
  kbuild: centralize .dts->.dtb rule
  kbuild: introduce cmd_dtc_cpp

 arch/arm/boot/Makefile           |    4 ----
 arch/arm/boot/dts/skeleton.dtsip |   13 +++++++++++++
 arch/c6x/boot/Makefile           |    3 ---
 arch/openrisc/boot/Makefile      |    3 ---
 arch/powerpc/boot/Makefile       |    4 ----
 scripts/Makefile.lib             |    9 +++++++++
 6 files changed, 22 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsip

