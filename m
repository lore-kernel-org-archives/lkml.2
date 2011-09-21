Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1IUJfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:35:08 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37829 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1IUJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:35:05 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 42/57] sony-laptop:irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:43 +0800
Message-Id: <1316597339-29861-43-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
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

