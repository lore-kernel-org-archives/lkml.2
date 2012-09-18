Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2IRKw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:52:26 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:55386 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2IRKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:52:25 -0400
Subject: [Re: [PATCH 2/2] drivers/s390/net/ctcm_main.c: fix error return
 code]
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: blaschka@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com,
        heicars2@linux.vnet.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 12:52:19 +0200
Message-ID: <1347965539.29091.3.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 12091810-1948-0000-0000-000002FB3D83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


thanks, Peter, your patch will be added to our next patch series
submission.

Ursula Braun











________________________________________________________________________



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
@@ -1454,7 +1454,7 @@ static int add_channel(struct ccw_device *cdev,
enum ctcm_channel_types type,

ch_fsm_len, GFP_KERNEL);
                 }
                 if (ch->fsm == NULL)
-
 goto free_return;
+
 goto nomem_return;

                 fsm_newstate(ch->fsm, CTC_STATE_IDLE);

-- 
1.7.11.4




