Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2JSDWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:22:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:54511 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964943Ab2JSDRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Pagano <mpagano@gentoo.org>
Subject: [ 19/37] tg3: Apply short DMA frag workaround to 5906
Date: Thu, 18 Oct 2012 20:16:42 -0700
Message-Id: <20121019031305.945763469@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit b7abee6ef888117f92db370620ebf116a38e3f4d upstream.

5906 devices also need the short DMA fragment workaround.  This patch
makes the necessary change.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Mike Pagano <mpagano@gentoo.org>

---
 drivers/net/tg3.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -13689,8 +13689,9 @@ static int __devinit tg3_get_invariants(
 	 */
 	tg3_flag_set(tp, 4G_DMA_BNDRY_BUG);
 
-	if (tg3_flag(tp, 5755_PLUS))
-		tg3_flag_set(tp, SHORT_DMA_BUG);
+	if (tg3_flag(tp, 5755_PLUS) ||
+		GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906)
+			tg3_flag_set(tp, SHORT_DMA_BUG);
 	else
 		tg3_flag_set(tp, 40BIT_DMA_LIMIT_BUG);
 


