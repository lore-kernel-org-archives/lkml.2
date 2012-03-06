Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2CFJNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:13:54 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:50485 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2CFJNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:13:51 -0500
X-Greylist: delayed 1679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Mar 2012 04:13:50 EST
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: linux-tegra@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: [PATCH/RFC 0/2] Couple of Tegra2 PCIe fixes(?)
Date: Tue,  6 Mar 2012 12:45:41 +0400
Message-Id: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.5.1.300.gc565c
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are more of RFC, because I can't test if 1/2 is really fixes anything,
and not sure how much 2/2 is needed - maybe error it fixes happens just in
my setup (and also I'm not sure if 2 seconds is a good value for timeout,
because I have no idea, how much time it takes for PLL to lock when everything)
But anyway...

While trying to make PCIe work on Harmony board, I've noticed
that pinmux groups for PCIe related signals are tristated, which 
looked suspicious. So I fixed that - that's the patch 1/2.

Sadly, even with this fix and 3.3v regulator patch[1] applied, PCIe still
doesn't work for me. Usually driver just loops infinitely in PLL lock
waiting code (that was the reason for writing patch 2/2 in this
mini-series). Couple of times I observed that after about 20-30 seconds of
waiting it passed PLL lock test and continue further, but then it failed to
detect a link with PCIe card. And I can't even reproduce this anymore.

Does anyone have working PCIe on Harmony? Can you please share the details
of your setup - what bootloader are you using, which version of kernel,
some additional patches maybe? Is there some secret tricks which are needed?
I've tried several combinations of different kernels and bootloaders, but
still can't find even a one which works.

[1] http://www.spinics.net/lists/linux-tegra/msg04148.html

Dmitry Artamonow (2):
  arm/tegra: fix harmony pinmux for PCIe
  arm/tegra: add timeout to PCIe PLL lock detection loop

 arch/arm/mach-tegra/board-harmony-pinmux.c |    6 +++---
 arch/arm/mach-tegra/pcie.c                 |   14 +++++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

-- 
1.7.5.1.300.gc565c

