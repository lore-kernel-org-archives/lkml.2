Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1CJRXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:23:52 -0500
Received: from asset.uwaterloo.ca ([129.97.92.29]:59488 "EHLO
	asset.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1CJRXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:23:51 -0500
Date: Thu, 10 Mar 2011 12:23:48 -0500
From: j223yang@asset.uwaterloo.ca
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch]iwch_cm: fix possible null pointer
Message-ID: <20110310172348.GA10787@asset.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bugzilla #9583:
https://bugzilla.kernel.org/show_bug.cgi?id=9583

The patch adds NULL check for 'ep->com.cm_id' before derefenrence, since
'ep->com.cm_id' is testing for NULL before. But it depends on the relationship
between 'status' and 'ep->com.cm_id'.

Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
---
 iwch_cm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c	2011-03-10 11:20:13.641039456 -0500
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c	2011-03-10 11:39:03.346164807 -0500
@@ -746,7 +746,8 @@ static void connect_reply_upcall(struct 
 		ep->com.cm_id->event_handler(ep->com.cm_id, &event);
 	}
 	if (status < 0) {
-		ep->com.cm_id->rem_ref(ep->com.cm_id);
+		if (ep->com.cm_id)
+			ep->com.cm_id->rem_ref(ep->com.cm_id);
 		ep->com.cm_id = NULL;
 		ep->com.qp = NULL;
 	}
