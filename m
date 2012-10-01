Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2JAW7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:39 -0400
Received: from 1wt.eu ([62.212.114.60]:34987 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab2JAW7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:37 -0400
Message-Id: <20121001225200.447394714@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jun Nie <njun@marvell.com>, "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 067/180] Bluetooth: add NULL pointer check in HCI
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Nie <njun@marvell.com>

commit d9319560b86839506c2011346b1f2e61438a3c73 upstream.

If we fail to find a hci device pointer in hci_uart, don't try
to deref the NULL one we do have.

Signed-off-by: Jun Nie <njun@marvell.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/bluetooth/hci_ldisc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index e3d4eda..e6f67b6 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -313,8 +313,10 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 
 		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 			hu->proto->close(hu);
-			hci_unregister_dev(hdev);
-			hci_free_dev(hdev);
+			if (hdev) {
+				hci_unregister_dev(hdev);
+				hci_free_dev(hdev);
+			}
 		}
 	}
 }
-- 
1.7.2.1.45.g54fbc



