Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2KVVVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:21:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab2KVSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 29/38] sky2: Fix for interrupt handler
Date: Wed, 21 Nov 2012 16:40:12 -0800
Message-Id: <20121122003907.507028431@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

commit d663d181b9e92d80c2455e460e932d34e7a2a7ae upstream.

Re-enable interrupts if it is not our interrupt

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/sky2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2929,8 +2929,10 @@ static irqreturn_t sky2_intr(int irq, vo
 
 	/* Reading this mask interrupts as side effect */
 	status = sky2_read32(hw, B0_Y2_SP_ISRC2);
-	if (status == 0 || status == ~0)
+	if (status == 0 || status == ~0) {
+		sky2_write32(hw, B0_Y2_SP_ICR, 2);
 		return IRQ_NONE;
+	}
 
 	prefetch(&hw->st_le[hw->st_idx]);
 


