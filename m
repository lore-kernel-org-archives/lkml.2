Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2JQOPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab2JQOPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:15:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/10] uapi: Allow automatic generation of uapi/asm/ header
 files
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Howells <dhowells@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Date: Wed, 17 Oct 2012 15:15:28 +0100
Message-ID: <20121017141528.29084.31602.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

Several arch/*/include/uapi/asm/* header simply include the
corresponding <asm-generic/*> file. This patch allows such files to be
specified in uapi/asm/Kbuild via "generic-y += ..." to be automatically
generated (similar to asm/Kbuild).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
---

 Makefile                     |    4 +++-
 scripts/Makefile.asm-generic |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 5be2ee8..366d0ab 100644
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

