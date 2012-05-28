Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2E1Dzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:55:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268Ab2E1D26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:58 -0400
Message-Id: <20120528031204.950186515@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 015/117] tilegx: enable SYSCALL_WRAPPERS support
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit e6d9668e119af44ae5bcd5f1197174531458afe3 upstream.

Some discussion with the glibc mailing lists revealed that this was
necessary for 64-bit platforms with MIPS-like sign-extension rules
for 32-bit values.  The original symptom was that passing (uid_t)-1 to
setreuid() was failing in programs linked -pthread because of the "setxid"
mechanism for passing setxid-type function arguments to the syscall code.
SYSCALL_WRAPPERS handles ensuring that all syscall arguments end up with
proper sign-extension and is thus the appropriate fix for this problem.

On other platforms (s390, powerpc, sparc64, and mips) this was fixed
in 2.6.28.6.  The general issue is tracked as CVE-2009-0029.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 96033e2..74239dd 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -11,6 +11,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 


