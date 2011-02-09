Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1BIPTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 10:19:22 -0500
Received: from imp03.mtu.ru ([62.5.255.20]:43393 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab1BIPTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 10:19:18 -0500
Message-ID: <4D52AF15.5070705@pavlinux.ru>
Date: Wed, 09 Feb 2011 18:13:25 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.2.13) Gecko/20101206 Microsoft/666 Notepad
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]: Not PCI_PROBE_MMCONF by default
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All!

Do not set PCI_PROBE_MMCONF flag by default, and enable
only if configured with  CONFIG_PCI_MMCONFIG

Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
---
 arch/x86/pci/common.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 5fe7502..625b477 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -17,8 +17,7 @@
 #include <asm/smp.h>
 #include <asm/pci_x86.h>

-unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
-                               PCI_PROBE_MMCONF;
+unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2;

 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
@@ -535,6 +534,9 @@ char * __devinit  pcibios_setup(char *str)
        }
 #endif
 #ifdef CONFIG_PCI_MMCONFIG
+
+       pci_probe |= PCI_PROBE_MMCONF;
+
        else if (!strcmp(str, "nommconf")) {
                pci_probe &= ~PCI_PROBE_MMCONF;
                return NULL;


-- 
                                                         Pavel.
