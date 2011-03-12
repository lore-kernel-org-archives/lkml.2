Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1CLWkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:40:10 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49015 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1CLWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=jC7MoAF+ACxfpmquH4XikV6BInHF6JNOk5yDDZBy45hZ+V9vM9RSAlnjoUSoFgRVjs
         YiDaS8Ene/phmIqjxzLcuYUNCScJI1NAE67KyUHd+t/vbf1mTbEctm+1M5tpVYAlNcHF
         6nrO/ikyDFHVu6Ewh0kOgeI5n6VP0kZp27ll8=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 2/3] USBNET: Introduce usbnet platform data
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:40:03 +0000
Message-ID: <20110312224003.27344.97018.stgit@otae.warmcat.com>
In-Reply-To: <20110312223643.27344.72406.stgit@otae.warmcat.com>
References: <20110312223643.27344.72406.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This defines optional platform_data for usbnet.  It allows
you to force eth%d name usage based on board-level knowledge
that it is soldered to a board and wired to an RJ45 on the board,
and to set the MAC address to a specific value from board
definition file.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 include/linux/usb/usbnet.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 44842c8..ad6ad94 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -195,6 +195,14 @@ struct skb_data {	/* skb->cb is one of these */
 	size_t			length;
 };
 
+#define USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME BIT(0)
+#define USBNET_PLATDATA_FLAG__USE_MAC BIT(1)
+
+struct usbnet_platform_data {
+	u8 mac[ETH_ALEN];
+	u32 flags;
+};
+
 extern int usbnet_open(struct net_device *net);
 extern int usbnet_stop(struct net_device *net);
 extern netdev_tx_t usbnet_start_xmit(struct sk_buff *skb,

