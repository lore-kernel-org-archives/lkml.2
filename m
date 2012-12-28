Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab2L1Tfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:35:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55438 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279Ab2L1TTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:02 -0500
Message-Id: <20121228190347.377322461@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 082/173] iscsit: use GFP_ATOMIC under spin lock
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 3c989d7603872bf878840f7ce3ea49b73bea4c6c upstream.

The function iscsit_build_conn_drop_async_message() is called
from iscsit_close_connection() with spin lock 'sess->conn_lock'
held, so we should use GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 4ad14ac..339f97f 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2336,7 +2336,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	if (!conn_p)
 		return;
 
-	cmd = iscsit_allocate_cmd(conn_p, GFP_KERNEL);
+	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
 	if (!cmd) {
 		iscsit_dec_conn_usage_count(conn_p);
 		return;


