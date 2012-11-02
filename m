Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853Ab2KBN7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:59:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47430 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2KBN7v convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 09:59:51 -0400
Message-Id: <5093E00D02000078000A60E2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:00:29 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/HPET: fix inverted return value check in
 arch_setup_hpet_msi()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_hpet_msi_remapped() returns a negative error indicator on error
- check for this rather than for a boolean false indication, and pass
on that error code rather than a meaningless "-1".

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---
 arch/x86/kernel/apic/io_apic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- 3.7-rc3/arch/x86/kernel/apic/io_apic.c
+++ 3.7-rc3-x86-hpet-masking/arch/x86/kernel/apic/io_apic.c
@@ -3317,8 +3317,9 @@ int arch_setup_hpet_msi(unsigned int irq
 	int ret;
 
 	if (irq_remapping_enabled) {
-		if (!setup_hpet_msi_remapped(irq, id))
-			return -1;
+		ret = setup_hpet_msi_remapped(irq, id);
+		if (ret)
+			return ret;
 	}
 
 	ret = msi_compose_msg(NULL, irq, &msg, id);



