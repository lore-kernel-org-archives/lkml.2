Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2BSCK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 21:10:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab2BSCKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 21:10:54 -0500
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Date: Sun, 19 Feb 2012 13:10:00 +1100
Subject: [PATCH 1/3] w1_bq27000: remove unnecessary NULL test.
Cc: GregKH <greg@kroah.com>, Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Message-ID: <20120219021000.4958.45388.stgit@notabene.brown>
In-Reply-To: <20120219020910.4958.46866.stgit@notabene.brown>
References: <20120219020910.4958.46866.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As recent change means that we now dereference 'dev' before testing
for NULL.

That means either the change was wrong, or the test isn't needed.
As this function is only called from one driver (bq27x000_battery) and
it always passed a non-NULL dev, it seems good to assume that the
test isn't needed.

So remove it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/slaves/w1_bq27000.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 8f10fd2..50d9af7 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -45,9 +45,6 @@ static int w1_bq27000_read(struct device *dev, unsigned int reg)
 	u8 val;
 	struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
 
-	if (!dev)
-		return 0;
-
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val = w1_read_8(sl->master);
 


