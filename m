Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0GALXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:23:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0GALXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sAPdSx+jqBX+huVhmZB8T+AIWuOTkSwZ25GWj9BmJ0Vwpe5jYuG4LnMIgj+mFfkbzX
         Ctv3TTk09pb4e/uD/zBoAaOTqIWw85dPSDI6CEY87YMK+ExFO5MWTWAh2nb7PEBQFlFo
         kGvRuFi3RVa4bRaFIcH+um4rHP/WsJnD5FDX8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, John Youn <John.Youn@synopsys.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] drivers/usb/host: use ARRAY_SIZE
Date: Thu,  1 Jul 2010 15:23:12 +0400
Message-Id: <1277983394-30198-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/host/xhci-mem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fd9e03a..1fcef80 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1566,7 +1566,7 @@ static int xhci_check_trb_in_td_math(struct xhci_hcd *xhci, gfp_t mem_flags)
 	unsigned int num_tests;
 	int i, ret;
 
-	num_tests = sizeof(simple_test_vector) / sizeof(simple_test_vector[0]);
+	num_tests = ARRAY_SIZE(simple_test_vector);
 	for (i = 0; i < num_tests; i++) {
 		ret = xhci_test_trb_in_td(xhci,
 				xhci->event_ring->first_seg,
@@ -1579,7 +1579,7 @@ static int xhci_check_trb_in_td_math(struct xhci_hcd *xhci, gfp_t mem_flags)
 			return ret;
 	}
 
-	num_tests = sizeof(complex_test_vector) / sizeof(complex_test_vector[0]);
+	num_tests = ARRAY_SIZE(complex_test_vector);
 	for (i = 0; i < num_tests; i++) {
 		ret = xhci_test_trb_in_td(xhci,
 				complex_test_vector[i].input_seg,
-- 
1.7.0.4

