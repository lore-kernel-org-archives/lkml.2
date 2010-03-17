Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0CQVQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:16:50 -0400
Received: from mail.pxnet.com ([195.227.45.7]:49662 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab0CQVQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:16:48 -0400
From: Tilman Schmidt <tilman@imap.cc>
Date: Wed, 17 Mar 2010 18:37:05 +0100
Subject: [PATCH] gigaset: fix build failure
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>,
       isdn4linux <isdn4linux@listserv.isdn4linux.de>,
       i4ldeveloper <i4ldeveloper@listserv.isdn4linux.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Message-Id: <20100317211231.569B140118@xenon.ts.pxnet.com>
X-Spam-Score: -1.527 () AWL,BAYES_00,DATE_IN_PAST_03_06,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the dummy LL interface to the LL interface change
introduced by commit daab433c03c15fd642c71c94eb51bdd3f32602c8.
This fixes the build failure occurring after that commit when
enabling ISDN_DRV_GIGASET but neither ISDN_I4L nor ISDN_CAPI.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/dummyll.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/gigaset/dummyll.c b/drivers/isdn/gigaset/dummyll.c
index 5b27c99..bd0b1ea 100644
--- a/drivers/isdn/gigaset/dummyll.c
+++ b/drivers/isdn/gigaset/dummyll.c
@@ -57,12 +57,20 @@ void gigaset_isdn_stop(struct cardstate *cs)
 {
 }
 
-int gigaset_isdn_register(struct cardstate *cs, const char *isdnid)
+int gigaset_isdn_regdev(struct cardstate *cs, const char *isdnid)
 {
-	pr_info("no ISDN subsystem interface\n");
 	return 1;
 }
 
-void gigaset_isdn_unregister(struct cardstate *cs)
+void gigaset_isdn_unregdev(struct cardstate *cs)
+{
+}
+
+void gigaset_isdn_regdrv(void)
+{
+	pr_info("no ISDN subsystem interface\n");
+}
+
+void gigaset_isdn_unregdrv(void)
 {
 }
-- 
1.6.5.3.298.g39add

