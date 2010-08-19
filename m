Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab0HSWrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:47:04 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:33536 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab0HSWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:47:01 -0400
Date: Fri, 20 Aug 2010 00:46:16 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, konrad.wilk@oracle.com, jeremy@goop.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH] arch/x86/kernel/apic/io_apic.c: Fix for crash when apic=debug is used
Message-ID: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the patch fixing crash when apic=debug
is used and APIC is not properly initialized.
This issue appears during Xen Dom0 kernel boot
(git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git,
xen/stable-2.6.32.x head), however I think that
patch is rather generic and should be applied
to mainline kernel (it applies to Linux Kernel
Ver. 2.6.35 and Ver. 2.6.32.19 with small fuzz).

Daniel

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 arch/x86/kernel/apic/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e41ed24..2b18af1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1728,6 +1728,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 		struct irq_pin_list *entry;
 
 		cfg = desc->chip_data;
+		if (!cfg)
+			continue;
 		entry = cfg->irq_2_pin;
 		if (!entry)
 			continue;
