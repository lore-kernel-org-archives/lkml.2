Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2IQBEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:04:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33784 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab2IQAvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:05 -0400
Message-Id: <20120917003634.835570508@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 062/135] Bluetooth: RFCOMM - Fix info leak in  ioctl(RFCOMMGETDEVLIST)
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit f9432c5ec8b1e9a09b9b0e5569e3c73db8de432a ]

The RFCOMM code fails to initialize the two padding bytes of struct
rfcomm_dev_list_req inserted for alignment before copying it to
userland. Additionally there are two padding bytes in each instance of
struct rfcomm_dev_info. The ioctl() that for disclosures two bytes plus
dev_num times two bytes uninitialized kernel heap memory.

Allocate the memory using kzalloc() to fix this issue.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/rfcomm/tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index c258796..bc1eb56 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -471,7 +471,7 @@ static int rfcomm_get_dev_list(void __user *arg)
 
 	size = sizeof(*dl) + dev_num * sizeof(*di);
 
-	dl = kmalloc(size, GFP_KERNEL);
+	dl = kzalloc(size, GFP_KERNEL);
 	if (!dl)
 		return -ENOMEM;
 


