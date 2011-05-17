Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1EQWLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:11:44 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60361
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932465Ab1EQWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:11:42 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Connector: Correctly set the error code in case of success when dispatching receive callbacks
Date: Tue, 17 May 2011 15:25:38 -0700
Message-Id: <1305671138-19443-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305671138-19443-1-git-send-email-kys@microsoft.com>
References: <1305671138-19443-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes to the connector code introduced this bug where even
when a callback was invoked, we would return an error resulting in
double freeing of the skb. This patch fixes this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/connector/connector.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index d770058..c36fbe1 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -139,6 +139,7 @@ static int cn_call_callback(struct sk_buff *skb)
 	spin_unlock_bh(&dev->cbdev->queue_lock);
 
 	if (cbq != NULL) {
+		err = 0;
 		cbq->callback(msg, nsp);
 		kfree_skb(skb);
 		cn_queue_release_callback(cbq);
-- 
1.7.4.1

