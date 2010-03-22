Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0CVHXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49621 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab0CVHXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2/5] i2c-bfin-twi: add debug output for error status
Date: Mon, 22 Mar 2010 03:23:17 -0400
Message-Id: <1269242600-30147-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
References: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Add some debug() code to decode the error register.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index e016b1b..758bb1f 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -156,6 +156,18 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
 		write_MASTER_CTL(iface, 0);
 		SSYNC();
 		iface->result = -EIO;
+
+		if (mast_stat & LOSTARB)
+			dev_dbg(&iface->adap.dev, "Lost Arbitration\n");
+		if (mast_stat & ANAK)
+			dev_dbg(&iface->adap.dev, "Address Not Acknowledged\n");
+		if (mast_stat & DNAK)
+			dev_dbg(&iface->adap.dev, "Data Not Acknowledged\n");
+		if (mast_stat & BUFRDERR)
+			dev_dbg(&iface->adap.dev, "Buffer Read Error\n");
+		if (mast_stat & BUFWRERR)
+			dev_dbg(&iface->adap.dev, "Buffer Write Error\n");
+
 		/* if both err and complete int stats are set, return proper
 		 * results.
 		 */
-- 
1.7.0.2

