Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab0EJWxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:53:41 -0400
Received: from kroah.org ([198.145.64.141]:33242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0EJWwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:31 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:23 2010
Message-Id: <20100510223323.705996130@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Darren Jenkins <darrenrjenkins@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [070/117] drivers/net/wireless/p54/txrx.c Fix off by one error
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Darren Jenkins <darrenrjenkins@gmail.com>

commit 088ea189c4c75cdf211146faa4b341a0f7476be6 upstream.

fix off by one error in the queue size check of p54_tx_qos_accounting_alloc()

Coverity CID: 13314

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -186,7 +186,7 @@ static int p54_tx_qos_accounting_alloc(s
 	struct ieee80211_tx_queue_stats *queue;
 	unsigned long flags;
 
-	if (WARN_ON(p54_queue > P54_QUEUE_NUM))
+	if (WARN_ON(p54_queue >= P54_QUEUE_NUM))
 		return -EINVAL;
 
 	queue = &priv->tx_stats[p54_queue];


