Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2BSCLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 21:11:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab2BSCLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 21:11:04 -0500
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Date: Sun, 19 Feb 2012 13:10:00 +1100
Subject: [PATCH 2/3] w1_bq27000 - remove w1_bq27000_write
Cc: GregKH <greg@kroah.com>, Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120219021000.4958.32966.stgit@notabene.brown>
In-Reply-To: <20120219020910.4958.46866.stgit@notabene.brown>
References: <20120219020910.4958.46866.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is never used so remove it to avoid bit-rot.
It can trivially be re-added if there is ever a need.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/slaves/w1_bq27000.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 50d9af7..6ae60aa 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -26,20 +26,6 @@
 
 static int F_ID;
 
-void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
-{
-	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
-
-	if (!dev) {
-		pr_info("Could not obtain slave dev ptr\n");
-		return;
-	}
-
-	w1_write_8(sl->master, HDQ_CMD_WRITE | reg);
-	w1_write_8(sl->master, buf);
-}
-EXPORT_SYMBOL(w1_bq27000_write);
-
 static int w1_bq27000_read(struct device *dev, unsigned int reg)
 {
 	u8 val;


