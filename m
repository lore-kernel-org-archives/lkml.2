Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1IVJGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:06:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1IVJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:06:01 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 42/55] sony-laptop:irq: Remove IRQF_DISABLED
Date: Thu, 22 Sep 2011 16:59:09 +0800
Message-Id: <1316681962-8217-43-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 drivers/platform/x86/sony-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index bbd182e..c006dee 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -3281,7 +3281,7 @@ static int sony_pic_add(struct acpi_device *device)
 	/* request IRQ */
 	list_for_each_entry_reverse(irq, &spic_dev.interrupts, list) {
 		if (!request_irq(irq->irq.interrupts[0], sony_pic_irq,
-					IRQF_DISABLED, "sony-laptop", &spic_dev)) {
+					0, "sony-laptop", &spic_dev)) {
 			dprintk("IRQ: %d - triggering: %d - "
 					"polarity: %d - shr: %d\n",
 					irq->irq.interrupts[0],
-- 
1.7.4.1

