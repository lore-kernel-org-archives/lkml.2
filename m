Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967042Ab0GSVnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:43:49 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53691 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966865Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213852.925498470@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:29 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 11/25] GRU - interrupt fix for processors without core 0
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_interrupt_0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

GRU interrupts for the kernel context are targeted to core 0
of the lowest socket on the blade.

Fix an endcase for 6-socket processors that do not have a
APICID for core 0. (There are potentially 8 cores in the
socket. A 6 core socket has 2 cores disabled. If core 0 was
disabled, the old code did not work).

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grumain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2010-06-09 08:11:43.740083860 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2010-06-09 08:11:44.128107324 -0500
@@ -618,7 +618,7 @@ void gru_load_context(struct gru_thread_
 		cch->unmap_enable = 1;
 		cch->tfm_done_bit_enable = 1;
 		cch->cb_int_enable = 1;
-		cch->tlb_int_select = 0;	/* For now, ints go to cpu 0 */
+		cch->tlb_int_select = uv_cpu_core_number(0); /* For now, ints go to cpu 0 */
 	} else {
 		cch->unmap_enable = 0;
 		cch->tfm_done_bit_enable = 0;

