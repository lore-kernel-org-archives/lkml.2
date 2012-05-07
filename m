Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2EGGuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:50:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16312 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2EGGuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:50:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 06 May 2012 23:49:37 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        swarren@wwwdotorg.org, olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 0/2] i2c: tegra: cleanup and bug fixes.
Date: Mon,  7 May 2012 12:16:18 +0530
Message-Id: <1336373179-12739-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following two changes:
1. Using devm_* for all allocation.
    This will reduce the code size for freeing resources.
2. Notifying transfer complete after clearing the interrupt status.
   This is to avoid the misconfiguration of i2c register in multi-core
   environment.

Laxman Dewangan (2):
  i2c: tegra: make all resource allocation through devm_*
  i2c: tegra: notify transfer-complete after clearing status.

 drivers/i2c/busses/i2c-tegra.c |   79 +++++++++++++---------------------------
 1 files changed, 25 insertions(+), 54 deletions(-)

