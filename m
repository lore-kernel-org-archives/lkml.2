Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab1LLGvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 01:51:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1LLGvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 01:51:13 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] input: signedness bug in cma3000_thread_irq()
Date: Mon, 12 Dec 2011 01:49:26 -0500
Message-Id: <1323672566-16738-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error check (intr_status < 0) didn't work because intr_status is
a u8.  Change its type to signed int.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index 80793f1..06517e6 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -115,8 +115,8 @@ static void decode_mg(struct cma3000_accl_data *data, int *datax,
 static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
 {
 	struct cma3000_accl_data *data = dev_id;
-	int datax, datay, dataz;
-	u8 ctrl, mode, range, intr_status;
+	int datax, datay, dataz, intr_status;
+	u8 ctrl, mode, range;
 
 	intr_status = CMA3000_READ(data, CMA3000_INTSTATUS, "interrupt status");
 	if (intr_status < 0)
-- 
1.7.5.4

