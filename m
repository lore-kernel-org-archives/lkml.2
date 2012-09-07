Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2IFOhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:37:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2IFOhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:37:01 -0400
From: Huang Shijie <shijie8@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH 2/2] serial: mxs-auart: put the device in mxs_auart_probe()
Date: Thu,  6 Sep 2012 22:38:41 -0400
Message-Id: <1346985521-2248-2-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1346985521-2248-1-git-send-email-shijie8@gmail.com>
References: <1346985521-2248-1-git-send-email-shijie8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call the get_device() in the mxs_auart_probe().
For the balance of the reference count, we should put the
device in the mxs_auart_remove().

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/tty/serial/mxs-auart.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index ea5f888..6898413 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -796,6 +796,7 @@ static int __devexit mxs_auart_remove(struct platform_device *pdev)
 
 	auart_port[pdev->id] = NULL;
 
+	put_device(s->dev);
 	clk_put(s->clk);
 	free_irq(s->irq, s);
 	kfree(s);
-- 
1.7.4.4

