Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0JNEF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:05:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49431 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JNEFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:05:23 -0400
Date: Wed, 13 Oct 2010 21:00:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, x86@kernel.org
Subject: [PATCH -next] x86/vsmp: eliminate kconfig dependency warning
Message-Id: <20101013210023.9a033222.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning to satisfy dependencies:

warning: (X86_VSMP && X86_64 && PCI && X86_EXTENDED_PLATFORM || XEN && PARAVIRT_GUEST && (X86_64 || X86_32 && X86_PAE && !X86_VISWS) && X86_CMPXCHG && X86_TSC || KVM_CLOCK && PARAVIRT_GUEST || KVM_GUEST && PARAVIRT_GUEST || LGUEST_GUEST && PARAVIRT_GUEST && X86_32) selects PARAVIRT which has unmet direct dependencies (PARAVIRT_GUEST)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101013.orig/arch/x86/Kconfig
+++ linux-next-20101013/arch/x86/Kconfig
@@ -342,6 +342,7 @@ endif
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
+	select PARAVIRT_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
