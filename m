Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032919Ab2I1VNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:13:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34544 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759494Ab2I1Ukf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:35 -0400
X-Sasl-enc: 5YF6/MV5O83tgT6pMbRCn639QGmi7m67F9X2bhCp7w8c 1348864832
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 013/127] Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
Date: Fri, 28 Sep 2012 13:33:06 -0700
Message-Id: <20120928203047.350636367@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -471,7 +471,7 @@ static int rfcomm_get_dev_list(void __us
 
 	size = sizeof(*dl) + dev_num * sizeof(*di);
 
-	dl = kmalloc(size, GFP_KERNEL);
+	dl = kzalloc(size, GFP_KERNEL);
 	if (!dl)
 		return -ENOMEM;
 


