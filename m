Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2KAFmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:42:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2KAFmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:42:33 -0400
Date: Wed, 31 Oct 2012 22:42:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [patch] x86, xen: fix build dependency when USB_SUPPORT is not
 enabled
Message-ID: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_XEN_DOM0 must depend on CONFIG_USB_SUPPORT, otherwise there is no 
definition of xen_dbgp_reset_prep() and xen_dbgp_external_startup() 
resulting in the following link error:

drivers/built-in.o: In function `dbgp_reset_prep':
(.text+0x1e03c5): undefined reference to `xen_dbgp_reset_prep'
drivers/built-in.o: In function `dbgp_external_startup':
(.text+0x1e0d55): undefined reference to `xen_dbgp_external_startup'

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/xen/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -17,6 +17,7 @@ config XEN_DOM0
 	def_bool y
 	depends on XEN && PCI_XEN && SWIOTLB_XEN
 	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
+	depends on USB_SUPPORT
 
 # Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
 # name in tools.
