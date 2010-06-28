Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0F1Lzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:55:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0F1Lzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZlBYcFLyhyPiNmNqsVDZirZVM3EgQBV9NtiTtRTeOmO4q0bA4bajZR1Lfg3QDoudLg
         OKZKbiKOP88sgHPs3Dpl6zHSYHwS2D70ZeCiHxYe8K0BOsl3saNlgrXNrPOBwyw6WkTp
         d6IEDkusIUWpCKX0jjvql0ZVL69JtzP5HMp0A=
From: Kulikov Vasiliy <segooon@gmail.com>
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, John Youn <John.Youn@synopsys.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:46 +0400
Message-Id: <1277726147-24933-1-git-send-email-segooon@gmail.com>
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

