Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3AHXvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:51:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53649 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3AHXh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:29 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 27/77] p54spi: Add missing spin_lock_init
Date: Tue, 8 Jan 2013 18:35:06 -0500
Message-ID: <1357688156-25387-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Büsch <m@bues.ch>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 32d3a3922d617a5a685a5e2d24b20d0e88f192a9 upstream.

The tx_lock is not initialized properly. Add spin_lock_init().

Signed-off-by: Michael Buesch <m@bues.ch>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/p54/p54spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index c8f09da..4cede24 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -651,6 +651,7 @@ static int __devinit p54spi_probe(struct spi_device *spi)
 	init_completion(&priv->fw_comp);
 	INIT_LIST_HEAD(&priv->tx_pending);
 	mutex_init(&priv->mutex);
+	spin_lock_init(&priv->tx_lock);
 	SET_IEEE80211_DEV(hw, &spi->dev);
 	priv->common.open = p54spi_op_start;
 	priv->common.stop = p54spi_op_stop;
-- 
1.7.12.1

