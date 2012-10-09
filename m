Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2JIUAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:00:15 -0400
Received: from mxout1.idt.com ([157.165.5.25]:33672 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab2JIUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:00:07 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: [PATCH 1/3] rapidio: use msleep in discovery wait
Date: Tue,  9 Oct 2012 15:57:54 -0400
Message-Id: <1349812676-27057-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1349812676-27057-1-git-send-email-alexandre.bounine@idt.com>
References: <1349812676-27057-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msleep() routine for code clarity as suggested by Andrew Morton in his
comments for the original patch: https://lkml.org/lkml/2012/10/3/546.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/rapidio/rio-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 48e9041..05f0ed9 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -1391,7 +1391,7 @@ int __devinit rio_disc_mport(struct rio_mport *mport)
 		while (time_before(jiffies, to_end)) {
 			if (rio_enum_complete(mport))
 				goto enum_done;
-			schedule_timeout_uninterruptible(msecs_to_jiffies(10));
+			msleep(10);
 		}
 
 		pr_debug("RIO: discovery timeout on mport %d %s\n",
-- 
1.7.8.4

