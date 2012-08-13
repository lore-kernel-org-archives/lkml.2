Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2HMUXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:23:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab2HMUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Karsten Keil <keil@b1-systems.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/82] mISDN: Bugfix for layer2 fixed TEI mode
Date: Mon, 13 Aug 2012 13:19:15 -0700
Message-Id: <20120813201749.854428543@linuxfoundation.org>
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

commit 25099335944a23db75d4916644122c746684e093 upstream.

If a fixed TEI is used, the initial state of the layer 2 statmachine need to be
4 (TEI assigned). This was true only for Point to Point connections, but not
for the other fixed TEIs. It was not found before, because usually only the
TEI 0 is used as fixed TEI for PtP mode, but if you try X31 packet mode
connections with SAPI 16, TEI 1, it did fail.

Signed-off-by: Karsten Keil <keil@b1-systems.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/isdn/mISDN/layer2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/isdn/mISDN/layer2.c
+++ b/drivers/isdn/mISDN/layer2.c
@@ -2222,7 +2222,7 @@ create_l2(struct mISDNchannel *ch, u_int
 	InitWin(l2);
 	l2->l2m.fsm = &l2fsm;
 	if (test_bit(FLG_LAPB, &l2->flag) ||
-	    test_bit(FLG_PTP, &l2->flag) ||
+	    test_bit(FLG_FIXED_TEI, &l2->flag) ||
 	    test_bit(FLG_LAPD_NET, &l2->flag))
 		l2->l2m.state = ST_L2_4;
 	else


