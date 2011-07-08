Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab1GHFRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:17:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1GHFCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.315833988@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [037/107] Connector: Correctly set the error code in case of success when dispatching receive callbacks
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 663dd6dcaf7e95526e469e91f41972a9c0cca30c upstream.

The recent changes to the connector code introduced this bug where even
when a callback was invoked, we would return an error resulting in
double freeing of the skb. This patch fixes this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/connector/connector.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -139,6 +139,7 @@ static int cn_call_callback(struct sk_bu
 	spin_unlock_bh(&dev->cbdev->queue_lock);
 
 	if (cbq != NULL) {
+		err = 0;
 		cbq->callback(msg, nsp);
 		kfree_skb(skb);
 		cn_queue_release_callback(cbq);


