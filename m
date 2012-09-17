Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2IQIMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:12:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54604 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2IQIMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:12:13 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: ursula.braun@de.ibm.com
Cc: blaschka@linux.vnet.ibm.com, linux390@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/2] drivers/s390/net/ctcm_main.c: fix error return code
Date: Mon, 17 Sep 2012 10:12:01 +0200
Message-Id: <1347869521-2470-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869521-2470-1-git-send-email-peter.senna@gmail.com>
References: <1347869521-2470-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

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

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/s390/net/ctcm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 5227e57..98ea9cc 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1454,7 +1454,7 @@ static int add_channel(struct ccw_device *cdev, enum ctcm_channel_types type,
 				ch_fsm_len, GFP_KERNEL);
 	}
 	if (ch->fsm == NULL)
-				goto free_return;
+				goto nomem_return;
 
 	fsm_newstate(ch->fsm, CTC_STATE_IDLE);
 
-- 
1.7.11.4

