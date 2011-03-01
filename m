Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab1CASPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:15:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59213 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1CASPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:15:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oKQ0O5FuwcMcNGJFrexo+wDK+h00xzwRuVFF5VmDN1ARzMwXM3u0JQJFBYVRIolXAF
         ZoKaX1ESu6Tjczh4d0HZyd8OnbEkAaswzJvB8coTk7R9kN0CW0QiCgAz5Pn6ioW5RVk9
         l46uAC/asUSddoaM10JW7W0IKYv2Sshm8VvAI=
From: Pierre Tardy <tardyp@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org
Cc: Pierre Tardy <tardyp@gmail.com>
Subject: [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
Date: Tue,  1 Mar 2011 19:15:30 +0100
Message-Id: <cover.1298820825.git.tardyp@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find sdhci runtime_pm implementation.

It uses clock gating fw as a tip to know when our chip is idle.
It implements wake up from card insertion/removal.

This is RFC, please dont merge yet. I really would like to have deep review
from PCI linux-pm guys.

Opens are: 

1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
 are not duplicate from what the core is doing.

2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,
I'm not sure if I'm doing it the good way. 
We have the exact same issue for our not yet upstreamable usb-otg driver.
Not sure if this cannot be implemented generically in core.

version 1: was RFC and untested,
version 2: has been tested on intel medfield platform.
version 3: RFC, untested.
- Change runtime_pm initialization to match latest PCI framework scheme
- Added wake-up support

Pierre Tardy (2):
  mmc: sdhci: use ios->clock to know when sdhci is idle
  mmc: sdhci: handle wake-up from runtime_pm

Yunpeng Gao (1):
  mmc: sdhci-pci: Enable runtime PM support

 drivers/mmc/host/sdhci-pci.c |  117 +++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/sdhci.c     |   88 +++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 include/linux/mmc/sdhci.h    |    3 +
 scripts/checkpatch.pl        |    6 +-
 5 files changed, 215 insertions(+), 4 deletions(-)

