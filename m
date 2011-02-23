Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1BWBEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:04:50 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17330 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1BWBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:04:47 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jesper Juhl <jj@chaosbits.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH linux-next 2/8] pch_uart: add spin_lock_init
Date: Wed, 23 Feb 2011 10:03:13 +0900
Message-Id: <1298422999-4050-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1298422999-4050-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, spin_lock is not initialized.
Thus, add spin_lock_init().

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/pch_uart.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index bd5e980..9c631ab 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1369,6 +1369,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	priv->port.line = num++;
 	priv->trigger = PCH_UART_HAL_TRIGGER_M;
 
+	spin_lock_init(&priv->port.lock);
+
 	pci_set_drvdata(pdev, priv);
 	pch_uart_hal_request(pdev, fifosize, base_baud);
 
-- 
1.7.3.4

