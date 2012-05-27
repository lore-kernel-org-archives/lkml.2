Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2E0BF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:05:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2E0BFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:05:48 -0400
Message-Id: <20120527010423.935380372@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:24 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 01/94] tilegx: enable SYSCALL_WRAPPERS support
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -11,6 +11,7 @@ config TILE
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
 


