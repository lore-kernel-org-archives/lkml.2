Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab2JKQSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:18:36 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32973 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2JKQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] uapi: Allow automatic generation of uapi/asm/ header files
Date: Thu, 11 Oct 2012 17:18:02 +0100
Message-Id: <1349972285-22830-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
References: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 11 Oct 2012 16:18:11.0092 (UTC) FILETIME=[01EA6D40:01CDA7CC]
X-MC-Unique: 112101117181208101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9BGIi66011855

Several arch/*/include/uapi/asm/* header simply include the
corresponding <asm-generic/*> file. This patch allows such files to be
specified in uapi/asm/Kbuild via "generic-y += ..." to be automatically
generated (similar to asm/Kbuild).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 Makefile                     | 4 +++-
 scripts/Makefile.asm-generic | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 86eb6ac..5d0da36 100644
--- a/Makefile
+++ b/Makefile
@@ -437,7 +437,9 @@ endif
 PHONY += asm-generic
 asm-generic:
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
-	            obj=arch/$(SRCARCH)/include/generated/asm
+	            src=asm obj=arch/$(SRCARCH)/include/generated/asm
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.asm-generic \
+	            src=uapi/asm obj=arch/$(SRCARCH)/include/generated/uapi/asm
 
 # To make sure we do not include .config for any of the *config targets
 # catch them early, and hand them over to scripts/kconfig/Makefile
diff --git a/scripts/Makefile.asm-generic b/scripts/Makefile.asm-generic
index 40caf3c..d17e0ea 100644
--- a/scripts/Makefile.asm-generic
+++ b/scripts/Makefile.asm-generic
@@ -5,7 +5,7 @@
 # and for each file listed in this file with generic-y creates
 # a small wrapper file in $(obj) (arch/$(SRCARCH)/include/generated/asm)
 
-kbuild-file := $(srctree)/arch/$(SRCARCH)/include/asm/Kbuild
+kbuild-file := $(srctree)/arch/$(SRCARCH)/include/$(src)/Kbuild
 -include $(kbuild-file)
 
 include scripts/Kbuild.include

