Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1JJMtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:49:13 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:29760
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752643Ab1JJMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:49:11 -0400
X-SpamScore: 1
X-BigFish: VS1(zz1cddhzz1202hzzf29ahz2ei87h27ah668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPVD:NLI;H:oce-exbhcs03a.oce.net;RD:error;EFVD:FOP
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <20111010124154.464239811@gmail.com>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 14:38:27 +0200
From: Harro Haan <hrhaan@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Harro Haan <hrhaan@gmail.com>
Subject: [PATCH] fix ehci alignment error
Content-Disposition: inline; filename="fix-ehci-alignment-error.patch"
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Oct 2011 12:49:05.0733 (UTC) FILETIME=[FEB24F50:01CC874A]
Content-Type: text/plain
X-Bypass-Agent: EF-1;
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kirkwood gave an unaligned memory access error on
line 742 of drivers/usb/host/echi-hcd.c:
"ehci->last_periodic_enable = ktime_get_real();"

Signed-off-by: Harro Haan <hrhaan@gmail.com>
---
 include/linux/usb/hcd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 0097136..c0ecc5a 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -178,7 +178,7 @@ struct usb_hcd {
 	 * this structure.
 	 */
 	unsigned long hcd_priv[0]
-			__attribute__ ((aligned(sizeof(unsigned long))));
+			__attribute__ ((aligned(sizeof(s64))));
 };
 
 /* 2.4 does this a bit differently ... */
-- 
1.7.0.4




