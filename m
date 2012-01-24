Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2AXTJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:09:21 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2AXTJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:09:20 -0500
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: Switch to large mcmodel on x86_64
Date: Tue, 24 Jan 2012 20:09:12 +0100
Message-Id: <1327432152-26992-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 UML is unable to load modules if more than 504MiB
of memory are used.
This happens because on x86_64 the UML process has a quite high
start address (typically around 0x6000000).
If UML's memory is larger than 504MiB VMALLOC_START happens to be after
0x8000000. This is no problem unless one loads a module which was built
with R_X86_64_32S relocations.
Symbols with a location > 0x8000000 cannot be used with R_X86_64_32S

To deal with this x86_64 UML has to be compiled with -mcmodel=large
such that no R_X86_64_32S relocations are used.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reported-by: 전하늘 <allskyee@gmail.com>
---
 arch/um/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 28688e6..123f073 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -28,6 +28,7 @@ ifeq ($(SUBARCH),i386)
 endif
 ifeq ($(SUBARCH),x86_64)
         HEADER_ARCH := x86
+	KBUILD_CFLAGS += -mcmodel=large
 endif
 
 HOST_DIR := arch/$(HEADER_ARCH)
-- 
1.7.8.3

