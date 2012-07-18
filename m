Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2GRKaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:30:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46825 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab2GRKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:30:08 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Avi Kivity <avi@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Revert "KVM: Export asm-generic/kvm_para.h"
Date: Wed, 18 Jul 2012 11:29:53 +0100
Message-Id: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 56457f38f212344fb38b250cfa7e7311c065022f.

For architectures without asm/kvm_para.h, asm-generic/Kbuild
unconditionally tries to export the non-existent header file, resulting
in failure to build the user headers. Since the logic in
asm-generic/Kbuild.asm will only export the file if it exists (which in
turn causes linux/kvm_para.h to be exported), we can just remove the
unconditional header export.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Avi Kivity <avi@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

I'm not sure what specific problem the original commit was fixing, so we
may need to solve this another way if there's something I've missed.

 include/asm-generic/Kbuild |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 2c85a0f..53f91b1 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -8,7 +8,6 @@ header-y += int-ll64.h
 header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
-header-y += kvm_para.h
 header-y += mman-common.h
 header-y += mman.h
 header-y += msgbuf.h
-- 
1.7.4.1

