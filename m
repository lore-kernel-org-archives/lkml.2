Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1EFAYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:19 -0400
Received: from kroah.org ([198.145.64.141]:36573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab1EFAYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.534094064@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jie Yang <jie.yang@atheros.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [015/143] atl1c: duplicate atl1c_get_tpd
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jie Yang <jie.yang@atheros.com>

commit 678b77e265f6d66f1e68f3d095841c44ba5ab112 upstream.

remove duplicate atl1c_get_tpd, it may cause hardware to send wrong packets.

Signed-off-by: Jie Yang <jie.yang@atheros.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1c/atl1c_main.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -1976,8 +1976,6 @@ static void atl1c_tx_map(struct atl1c_ad
 		else {
 			use_tpd = atl1c_get_tpd(adapter, type);
 			memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
-			use_tpd = atl1c_get_tpd(adapter, type);
-			memcpy(use_tpd, tpd, sizeof(struct atl1c_tpd_desc));
 		}
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
 		buffer_info->length = buf_len - mapped_len;


