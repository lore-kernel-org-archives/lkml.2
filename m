Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2BSCLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 21:11:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab2BSCLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 21:11:14 -0500
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Date: Sun, 19 Feb 2012 13:10:00 +1100
Subject: [PATCH 3/3] w1_bq27000: Only one thread can access the bq27000 at a
 time.
Cc: GregKH <greg@kroah.com>, Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120219021000.4958.21513.stgit@notabene.brown>
In-Reply-To: <20120219020910.4958.46866.stgit@notabene.brown>
References: <20120219020910.4958.46866.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If multiple threads try, they trip over each other badly.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/slaves/w1_bq27000.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 6ae60aa..52ad812 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -31,8 +31,10 @@ static int w1_bq27000_read(struct device *dev, unsigned int reg)
 	u8 val;
 	struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
 
+	mutex_lock(&sl->master->mutex);
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val = w1_read_8(sl->master);
+	mutex_unlock(&sl->master->mutex);
 
 	return val;
 }


