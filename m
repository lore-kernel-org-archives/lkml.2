Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162286Ab2GLWp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:45:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162295Ab2GLWpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "David S. Miller" <davem@davemloft.net>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 167/187] tg3: Apply short DMA frag workaround to 5906
Date: Thu, 12 Jul 2012 15:35:23 -0700
Message-Id: <20120712191538.809523362@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit b7abee6ef888117f92db370620ebf116a38e3f4d upstream.

5906 devices also need the short DMA fragment workaround.  This patch
makes the necessary change.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14248,7 +14248,8 @@ static int __devinit tg3_get_invariants(
 		}
 	}
 
-	if (tg3_flag(tp, 5755_PLUS))
+	if (tg3_flag(tp, 5755_PLUS) ||
+	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906)
 		tg3_flag_set(tp, SHORT_DMA_BUG);
 
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719)


