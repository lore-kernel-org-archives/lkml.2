Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946243Ab2CPXkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:40:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946331Ab2CPXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:37 -0400
Message-Id: <20120316233812.391667919@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shreyas N Bhatewara <sbhatewara@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 20/41] vmxnet3: Fix transport header size
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Shreyas Bhatewara <sbhatewara@vmware.com>

[ Upstream commit efead8710aad9e384730ecf25eae0287878840d7 ]

Fix transport header size

Fix the transpoert header size for UDP packets.

Signed-off-by: Shreyas N Bhatewara <sbhatewara@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    7 +------
 drivers/net/vmxnet3/vmxnet3_int.h |    4 ++--
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -830,13 +830,8 @@ vmxnet3_parse_and_copy_hdr(struct sk_buf
 					ctx->l4_hdr_size = ((struct tcphdr *)
 					   skb_transport_header(skb))->doff * 4;
 				else if (iph->protocol == IPPROTO_UDP)
-					/*
-					 * Use tcp header size so that bytes to
-					 * be copied are more than required by
-					 * the device.
-					 */
 					ctx->l4_hdr_size =
-							sizeof(struct tcphdr);
+							sizeof(struct udphdr);
 				else
 					ctx->l4_hdr_size = 0;
 			} else {
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -70,10 +70,10 @@
 /*
  * Version numbers
  */
-#define VMXNET3_DRIVER_VERSION_STRING   "1.1.18.0-k"
+#define VMXNET3_DRIVER_VERSION_STRING   "1.1.29.0-k"
 
 /* a 32-bit int, each byte encode a verion number in VMXNET3_DRIVER_VERSION */
-#define VMXNET3_DRIVER_VERSION_NUM      0x01011200
+#define VMXNET3_DRIVER_VERSION_NUM      0x01011D00
 
 #if defined(CONFIG_PCI_MSI)
 	/* RSS only makes sense if MSI-X is supported. */


