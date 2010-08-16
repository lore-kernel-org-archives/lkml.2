Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0HPQ2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 12:28:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50913 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab0HPQ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 12:28:36 -0400
Date: Mon, 16 Aug 2010 18:28:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 14/16] drivers/w1/masters: Use available error codes
Message-ID: <Pine.LNX.4.64.1008161828190.19313@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error codes are stored in ret, but the return value is always 0.  Return
ret instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics of the function and has not been tested.

 drivers/w1/masters/omap_hdq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 3a7e9ff..2a71e62 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -396,7 +396,7 @@ static int hdq_read_byte(struct hdq_data *hdq_data, u8 *val)
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
-	return 0;
+	return ret;
 
 }
 
