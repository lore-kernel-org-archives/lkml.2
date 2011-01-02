Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1ABHl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:41:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:36588 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab1ABHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 179/260] x86, hpet: Fix bogus error check in hpet_assign_irq()
Date: Sun,  2 Jan 2011 02:17:55 -0500
Message-Id: <1293952756-15010-180-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:26.0760 (UTC) FILETIME=[F27BE280:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 021989622810b02aab4b24f91e1f5ada2b654579 upstream.

create_irq() returns -1 if the interrupt allocation failed, but the
code checks for irq == 0.

Use create_irq_nr() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.LFD.2.00.1009282310360.2416@localhost6.localdomain6>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 5294b58..c5f8121 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -499,7 +499,7 @@ static int hpet_assign_irq(struct hpet_dev *dev)
 {
 	unsigned int irq;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 
-- 
1.7.3.3

