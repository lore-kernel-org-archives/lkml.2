Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1HNQI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab1HNQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.109998213@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [57/90] r8169: Add support for D-Link 530T rev C1 (Kernel Bug 38862)
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

[ Upstream commit 93a3aa25933461d76141179fc94aa32d5f9d954a ]

The D-Link DGE-530T rev C1 is a re-badged Realtek 8169 named DLG10028C,
unlike the previous revisions which were skge based.  It is probably
the same as the discontinued DGE-528T (0x4300) other than the PCI ID.

The PCI ID is 0x1186:0x4302.

Adding it to r8169.c where 0x1186:0x4300 is already found makes the card
be detected and work.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=38862

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/r8169.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -236,6 +236,7 @@ static DEFINE_PCI_DEVICE_TABLE(rtl8169_p
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8168), 0, 0, RTL_CFG_1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK,	0x8169), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4300), 0, 0, RTL_CFG_0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DLINK,	0x4302), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AT,		0xc107), 0, 0, RTL_CFG_0 },
 	{ PCI_DEVICE(0x16ec,			0x0116), 0, 0, RTL_CFG_0 },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,


