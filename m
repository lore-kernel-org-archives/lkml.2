Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab2KNFuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55018 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab2KNFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:15 -0500
Message-Id: <20121114053944.848687480@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cyril Brulebois <kibi@debian.org>,
        Florent Fourcot <florent.fourcot@enst-bretagne.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 80/82] r8169: Fix WoL on RTL8168d/8111d.
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Brulebois <kibi@debian.org>

commit b00e69dee4ccbb3a19989e3d4f1385bc2e3406cd upstream.

This regression was spotted between Debian squeeze and Debian wheezy
kernels (respectively based on 2.6.32 and 3.2). More info about
Wake-on-LAN issues with Realtek's 816x chipsets can be found in the
following thread: http://marc.info/?t=132079219400004

Probable regression from d4ed95d796e5126bba51466dc07e287cebc8bd19;
more chipsets are likely affected.

Tested on top of a 3.2.23 kernel.

Reported-by: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
Tested-by: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
Hinted-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Cyril Brulebois <kibi@debian.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index e7ff886..eb6a5e4 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3827,6 +3827,8 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	void __iomem *ioaddr = tp->mmio_addr;
 
 	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_25:
+	case RTL_GIGA_MAC_VER_26:
 	case RTL_GIGA_MAC_VER_29:
 	case RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32:


