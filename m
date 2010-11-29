Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0K2AmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:42:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41905 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0K2AmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=nFibTbalwgMd1/ev0dqyn13ckDLEB9IT3Tz/Hh+Jf4xAnk1PwqNLXD2/jzQvzn0P+i
         UlB22cryBDfKPtlfoMuDIH+xe3SjRx5754mMyMHejGOJQ33bBlL/K4hFcY4IQVi4ygFd
         zZRnOb1wOp3OZ1BqVzQQwA8twssq4rz/TaphM=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] apic/io_apic.c: Remove unused variable 'desc'.
Date: Sun, 28 Nov 2010 22:42:01 -0200
Message-Id: <9354bfd606c4f42b8433bfb1be173198e94f1d87.1290991196.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the following warning:

arch/x86/kernel/apic/io_apic.c: In function ‘ack_apic_level’:
arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable ‘desc’

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..31c493d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2430,7 +2430,6 @@ static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
 	irq_complete_move(cfg);
-- 
1.7.3.2.343.g7d43d

