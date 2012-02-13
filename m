Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2BMIp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 03:45:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2BMIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 03:45:56 -0500
MIME-Version: 1.0
X-Originating-IP: [212.34.73.1]
Date: Mon, 13 Feb 2012 09:45:54 +0100
X-Google-Sender-Auth: ctfQ-pQc5EzW0Y109l7Rr6NMFFY
Message-ID: <CAJafhzQV821ij62y_TQr9M3jHyyDdovi0P30kidv7H8fsoqKPw@mail.gmail.com>
Subject: ixgbe truesize underestimation fix missing?
From: Christian Brunner <chb@muc.de>
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in Oktober, there was a patch by Eric Dumazet for the ixgbe
driver to fix the skb truesize underestimation (commit
98130646770db42cd14c44ba0d7f2d0eb8078820). It changed only one line in
ixgbe_main.c:

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1326,7 +1326,7 @@ static bool ixgbe_clean_rx_irq(struct
ixgbe_q_vector *q_vector,
                        skb->len += upper_len;
                        skb->data_len += upper_len;
-                       skb->truesize += upper_len;
+                       skb->truesize += PAGE_SIZE / 2;
                }                 i++;


But when I look at the current code (3.2.5 or 3.3rc), skb->truesize is
still increased by the same value as skb->data_len.

1228         skb->data_len += frag_list_size;
1229         skb->truesize += frag_list_size;

Is it posible that there was a merge conflict, or am I missing something here?

Thanks,
Christian
