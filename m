Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1D2TKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:10:38 -0400
Received: from kroah.org ([198.145.64.141]:50171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620Ab1D2S6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.064485741@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        Jason Conti <jason.conti@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [05/55] p54: Initialize extra_len in p54_tx_80211
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Conti <jason.conti@gmail.com>

commit a6756da9eace8b4af73e9dea43f1fc2889224c94 upstream.

This patch fixes a very serious off-by-one bug in
the driver, which could leave the device in an
unresponsive state.

The problem was that the extra_len variable [used to
reserve extra scratch buffer space for the firmware]
was left uninitialized. Because p54_assign_address
later needs the value to reserve additional space,
the resulting frame could be to big for the small
device's memory window and everything would
immediately come to a grinding halt.

Reference: https://bugs.launchpad.net/bugs/722185

Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Jason Conti <jason.conti@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -705,7 +705,7 @@ int p54_tx_80211(struct ieee80211_hw *de
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len;
+	unsigned int padding, len, extra_len = 0;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;


