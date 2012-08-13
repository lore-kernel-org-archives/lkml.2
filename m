Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2HMUUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2HMUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Karsten Keil <keil@b1-systems.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/82] mISDN: Bugfix only few bytes are transfered on a connection
Date: Mon, 13 Aug 2012 13:18:46 -0700
Message-Id: <20120813201747.341043888@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karsten Keil <keil@b1-systems.de>

commit b41a9a66f67817f8acd85bd650e012a14da39faa upstream.

The test for the fillempty condition was wrong in one place.
Changed the variable to the right boolean type.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/hardware/mISDN/avmfritz.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -449,7 +449,8 @@ hdlc_fill_fifo(struct bchannel *bch)
 {
 	struct fritzcard *fc = bch->hw;
 	struct hdlc_hw *hdlc;
-	int count, fs, cnt = 0, idx, fillempty = 0;
+	int count, fs, cnt = 0, idx;
+	bool fillempty = false;
 	u8 *p;
 	u32 *ptr, val, addr;
 
@@ -462,7 +463,7 @@ hdlc_fill_fifo(struct bchannel *bch)
 			return;
 		count = fs;
 		p = bch->fill;
-		fillempty = 1;
+		fillempty = true;
 	} else {
 		count = bch->tx_skb->len - bch->tx_idx;
 		if (count <= 0)
@@ -477,7 +478,7 @@ hdlc_fill_fifo(struct bchannel *bch)
 			hdlc->ctrl.sr.cmd |= HDLC_CMD_XME;
 	}
 	ptr = (u32 *)p;
-	if (fillempty) {
+	if (!fillempty) {
 		pr_debug("%s.B%d: %d/%d/%d", fc->name, bch->nr, count,
 			 bch->tx_idx, bch->tx_skb->len);
 		bch->tx_idx += count;


