Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809Ab1LGQXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933742Ab1LGQXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:18 2011
Message-Id: <20111207161217.989094338@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:41 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Michael Buesch <m@bues.ch>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [039/104] p54spi: Add missing spin_lock_init
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>

commit 32d3a3922d617a5a685a5e2d24b20d0e88f192a9 upstream.

The tx_lock is not initialized properly. Add spin_lock_init().

Signed-off-by: Michael Buesch <m@bues.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54spi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -657,6 +657,7 @@ static int __devinit p54spi_probe(struct
 	init_completion(&priv->fw_comp);
 	INIT_LIST_HEAD(&priv->tx_pending);
 	mutex_init(&priv->mutex);
+	spin_lock_init(&priv->tx_lock);
 	SET_IEEE80211_DEV(hw, &spi->dev);
 	priv->common.open = p54spi_op_start;
 	priv->common.stop = p54spi_op_stop;


