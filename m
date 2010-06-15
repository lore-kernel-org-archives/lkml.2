Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0FONtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:49:05 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:58833 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0FONtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:49:01 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jun 2010 09:49:00 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
       linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/1] X86: pci, fix section mismatch
Date: Tue, 15 Jun 2010 15:43:19 +0200
Message-Id: <1276609399-21746-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
__devinit. Mark pcibios_scan_specific_bus __devinit as well since
all users are now __init or __devinit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/legacy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 8d460ea..c89266b 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -36,7 +36,7 @@ int __init pci_legacy_init(void)
 	return 0;
 }
 
-void pcibios_scan_specific_bus(int busn)
+void __devinit pcibios_scan_specific_bus(int busn)
 {
 	int devfn;
 	long node;
-- 
1.7.1


