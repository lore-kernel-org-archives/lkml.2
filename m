Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2JZAG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:06:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:52683 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab2JZAGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [ 04/42] arch/tile: avoid generating .eh_frame information in modules
Date: Thu, 25 Oct 2012 17:05:12 -0700
Message-Id: <20121026000125.242313236@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000124.790781113@linuxfoundation.org>
References: <20121026000124.790781113@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -26,6 +26,10 @@ $(error Set TILERA_ROOT or CROSS_COMPILE
   endif
 endif
 
+# The tile compiler may emit .eh_frame information for backtracing.
+# In kernel modules, this causes load failures due to unsupported relocations.
+KBUILD_CFLAGS   += -fno-asynchronous-unwind-tables
+
 ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 endif


