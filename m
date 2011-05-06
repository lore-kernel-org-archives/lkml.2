Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1EFAyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:54:05 -0400
Received: from kroah.org ([198.145.64.141]:36804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab1EFAYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:10 2011
Message-Id: <20110506002210.778991868@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Subject: [057/143] Staging: rtl8192su: check for skb == NULL
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Schilhabel <florian.c.schilhabel@googlemail.com>

commit 199ef62a287b429a8fa3b7dc5ae6b69f607bf324 upstream.

added 2 checks for skb == NULL.
plus cosmetics

Signed-off-by: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[bwh: Remove cosmetic changes]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/rtl8192su/r8192S_firmware.c |    5 +++++
 drivers/staging/rtl8192su/r819xU_cmdpkt.c   |    6 ++++++
 2 files changed, 11 insertions(+)

--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -68,6 +68,11 @@ bool FirmwareDownloadCode(struct net_dev
 
 		/* Allocate skb buffer to contain firmware info and tx descriptor info. */
 		skb  = dev_alloc_skb(frag_length);
+		if (skb == NULL) {
+			RT_TRACE(COMP_ERR, "(%s): unable to alloc skb buffer\n",
+								__func__);
+			goto cmdsend_downloadcode_fail;
+		}
 		memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
 
 		tcb_desc = (cb_desc*)(skb->cb + MAX_DEV_ADDR_SIZE);
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -56,6 +56,12 @@ SendTxCommandPacket(
 
 	//Get TCB and local buffer from common pool. (It is shared by CmdQ, MgntQ, and USB coalesce DataQ)
 	skb  = dev_alloc_skb(USB_HWDESC_HEADER_LEN + DataLen + 4);
+	if (skb == NULL) {
+		RT_TRACE(COMP_ERR, "(%s): unable to alloc skb buffer\n",
+								__func__);
+		rtStatus = false;
+		return rtStatus;
+	}
 	memcpy((unsigned char *)(skb->cb),&dev,sizeof(dev));
 	tcb_desc = (cb_desc*)(skb->cb + MAX_DEV_ADDR_SIZE);
 	tcb_desc->queue_index = TXCMD_QUEUE;


