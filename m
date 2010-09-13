Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab0IMXBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 19:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0IMXBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 19:01:33 -0400
Date: Mon, 13 Sep 2010 23:00:56 GMT
From: "tip-bot for basile@opensource.dyc.edu" <basile@opensource.dyc.edu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mail@cleeus.de, zorry@gentoo.org, akpm@linux-foundation.org,
        basile@opensource.dyc.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, zorry@gentoo.org, mail@cleeus.de,
        basile@opensource.dyc.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100913101319.748A1148E216@opensource.dyc.edu>
References: <20100913101319.748A1148E216@opensource.dyc.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, build: Disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y
Message-ID: <tip-08c2b394b98786ebb067e2a54d08f1f6f0d247da@git.kernel.org>
Git-Commit-ID: 08c2b394b98786ebb067e2a54d08f1f6f0d247da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 23:00:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08c2b394b98786ebb067e2a54d08f1f6f0d247da
Gitweb:     http://git.kernel.org/tip/08c2b394b98786ebb067e2a54d08f1f6f0d247da
Author:     basile@opensource.dyc.edu <basile@opensource.dyc.edu>
AuthorDate: Mon, 13 Sep 2010 06:13:19 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Sep 2010 15:53:16 -0700

x86, build: Disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y

The arch/x86/Makefile uses scripts/gcc-x86_$(BITS)-has-stack-protector.sh
to check if cc1 supports -fstack-protector.  When -fPIE is passed to cc1,
these scripts fail causing stack protection to be disabled even when it
is available.

This fix is similar to commit c47efe5548abbf53c2f66e06dcb46183b11d6b22

Reported-by: Kai Dietrich <mail@cleeus.de>
Signed-off-by: Magnus Granberg <zorry@gentoo.org>
LKML-Reference: <20100913101319.748A1148E216@opensource.dyc.edu>
Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8aa1b59..e8c8881 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -74,7 +74,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
                 stackp-y := -fstack-protector
                 KBUILD_CFLAGS += $(stackp-y)
         else
