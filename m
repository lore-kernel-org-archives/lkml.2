Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2J1XlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:41:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42016 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756753Ab2J1X1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:46 -0400
Message-Id: <20121028231557.965769953@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 068/105] arch/tile: avoid generating .eh_frame information in modules
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Metcalf <cmetcalf@tilera.com>

commit 627072b06c362bbe7dc256f618aaa63351f0cfe6 upstream.

The tile tool chain uses the .eh_frame information for backtracing.
The vmlinux build drops any .eh_frame sections at link time, but when
present in kernel modules, it causes a module load failure due to the
presence of unsupported pc-relative relocations.  When compiling to
use compiler feedback support, the compiler by default omits .eh_frame
information, so we don't see this problem.  But when not using feedback,
we need to explicitly suppress the .eh_frame.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/tile/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 55640cf..3d15364 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -26,6 +26,10 @@ $(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
   endif
 endif
 
+# The tile compiler may emit .eh_frame information for backtracing.
+# In kernel modules, this causes load failures due to unsupported relocations.
+KBUILD_CFLAGS   += -fno-asynchronous-unwind-tables
+
 ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 endif


