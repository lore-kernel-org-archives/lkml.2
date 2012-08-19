Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2HSIo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:44:56 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:47863 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab2HSIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216895"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Anton Vorontsov <cbou@mail.ru>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/14] drivers/power/bq27x00_battery.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:20 +0200
Message-Id: <1345365870-29831-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/power/bq27x00_battery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 181ddec..5860d4d 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -814,7 +814,8 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 	di->bat.name = name;
 	di->bus.read = &bq27x00_read_i2c;
 
-	if (bq27x00_powersupply_init(di))
+	retval = bq27x00_powersupply_init(di);
+	if (retval)
 		goto batt_failed_3;
 
 	i2c_set_clientdata(client, di);

