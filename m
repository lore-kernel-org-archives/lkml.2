Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1HXQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:14:58 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:33145 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1HXQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:14:52 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH 3/3] jsm: print byte we are dequeing
Date: Wed, 24 Aug 2011 13:14:23 -0300
Message-Id: <1314202463-12297-3-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314202463-12297-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1314202463-12297-1-git-send-email-cascardo@linux.vnet.ibm.com>
x-cbid: 11082416-9254-0000-0000-000006490C8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of printing the head of the buffer, we should print the tail,
which is the byte we are sending to the device.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/tty/serial/jsm/jsm_neo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index bd6e846..81dfafa 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -522,7 +522,7 @@ static void neo_copy_data_from_queue_to_uart(struct jsm_channel *ch)
 
 			writeb(circ->buf[circ->tail], &ch->ch_neo_uart->txrx);
 			jsm_printk(WRITE, INFO, &ch->ch_bd->pci_dev,
-					"Tx data: %x\n", circ->buf[circ->head]);
+					"Tx data: %x\n", circ->buf[circ->tail]);
 			circ->tail = (circ->tail + 1) & (UART_XMIT_SIZE - 1);
 			ch->ch_txcount++;
 		}
-- 
1.7.4.4

