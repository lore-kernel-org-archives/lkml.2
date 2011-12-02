Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1LBH16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 02:27:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36364 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1LBH15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 02:27:57 -0500
Date: Fri, 2 Dec 2011 08:27:53 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Jan Beulich <jbeulich@novell.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Frank Arnold <frank.arnold@amd.com>
Subject: [PATCH] x86, amd: Kill misleading message about enablement of IO
 access to PCI ECS
Message-ID: <20111202072753.GB31916@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Commit 24d9b70b8c679264756a6980e668b96b3f964826 (x86: Use PCI method
for enabling AMD extended config space before MSR method) added a
message when IO access to PCI ECS was enabled via access to the NB_CFG
PCI register.  This can lead to a bogus message like

[    0.365177] Extended Config Space enabled on 0 nodes

which is misleading because IO ECS access is subsequently enabled for
AMD CPUs (that support this) by modifying the corresponding NB_CFG
MSR.

Furthermore it's not "Extended Config Space" that is enabled by this
register setting. It's the IO access that is enabled for extended
configruation space.

IMHO the ambiguous message needs to be cancelled.

Cc: Jan Beulich <jbeulich@novell.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/pci/amd_bus.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 026e493..7b7a897 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -403,7 +403,6 @@ static void __init pci_enable_pci_io_ecs(void)
 			++n;
 		}
 	}
-	pr_info("Extended Config Space enabled on %u nodes\n", n);
 #endif
 }
 
-- 
1.7.8.rc4

