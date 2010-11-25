Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0KYPGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:06:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50944 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0KYPGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:06:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I77sWZJQar8nbAvcECAyOgQGp9mcTOrQgaozf0KzEy5YLaGOl7ok4lFST3Ef5OdM7D
         Ky2xO+iY5szUI6xF+PCjlfP8GbQwUIv6Cs8DmosV4HrB6CEZUvN/3xMjAPv0VdfpkIWe
         8YCq9kHz59tHQA8qLlh8IHfy4b5Enq8tux9J4=
From: Anoop P <anoop.pa@gmail.com>
To: linux-mips@linux-mips.org, dvomlehn@cisco.com
Cc: Anoop P A <anoop.pa@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Allow setup_irq call for VPE1 timer.
Date: Thu, 25 Nov 2010 20:37:12 +0530
Message-Id: <1290697632-6139-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

VSMP configuration can have seperate timer interrupts for each VPE.Need to setup IRQ for VPE1 timer.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/kernel/cevt-r4k.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index 2f4d7a9..7eaeacd 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -203,9 +203,10 @@ int __cpuinit r4k_clockevent_init(void)
 
 	clockevents_register_device(cd);
 
+#ifndef CONFIG_MIPS_MT_SMP
 	if (cp0_timer_irq_installed)
 		return 0;
-
+#endif
 	cp0_timer_irq_installed = 1;
 
 	setup_irq(irq, &c0_compare_irqaction);
-- 
1.7.0.4

