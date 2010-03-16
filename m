Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0CPR0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:26:11 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:46535 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab0CPR0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:26:09 -0400
From: Tilman Schmidt <tilman@imap.cc>
Date: Tue, 16 Mar 2010 18:04:01 +0100
Subject: [PATCH] gigaset: correct range checking off by one error
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Dan Carpenter <error27@gmail.com>, Hansjoerg Lipp <hjlipp@web.de>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Message-Id: <20100316172048.CBC5240116@xenon.ts.pxnet.com>
X-Spam-Score: -2.18 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct a potential array overrun due to an off by one error in the
range check on the CAPI CONNECT_REQ CIPValue parameter.
Found and reported by Dan Carpenter using smatch.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/capi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 4a31962..0220c19 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1301,7 +1301,7 @@ static void do_connect_req(struct gigaset_capi_ctr *iif,
 	}
 
 	/* check parameter: CIP Value */
-	if (cmsg->CIPValue > ARRAY_SIZE(cip2bchlc) ||
+	if (cmsg->CIPValue >= ARRAY_SIZE(cip2bchlc) ||
 	    (cmsg->CIPValue > 0 && cip2bchlc[cmsg->CIPValue].bc == NULL)) {
 		dev_notice(cs->dev, "%s: unknown CIP value %d\n",
 			   "CONNECT_REQ", cmsg->CIPValue);
-- 
1.6.5.3.298.g39add

