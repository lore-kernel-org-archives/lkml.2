Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab2CMAcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:32:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:48797 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965143Ab2CMAYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 162/196] powerpc/boot/dts: Install dts from the right directory
Date: Mon, 12 Mar 2012 20:21:15 -0400
Message-Id: <1331598109-31424-117-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4d9ef89dee13e964ea8b064d82ff55cf36209237 upstream.

The dts-installed variable is initialised using a wildcard path that
will be expanded relative to the build directory.  Use the existing
variable dtstree to generate an absolute wildcard path that will work
when building in a separate directory.

Reported-by: Gerhard Pircher <gerhard_pircher@gmx.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Gerhard Pircher <gerhard_pircher@gmx.net> [against 2.6.32]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index bb2465b..22b527b 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -367,7 +367,7 @@ INSTALL := install
 extra-installed		:= $(patsubst $(obj)/%, $(DESTDIR)$(WRAPPER_OBJDIR)/%, $(extra-y))
 hostprogs-installed	:= $(patsubst %, $(DESTDIR)$(WRAPPER_BINDIR)/%, $(hostprogs-y))
 wrapper-installed	:= $(DESTDIR)$(WRAPPER_BINDIR)/wrapper
-dts-installed		:= $(patsubst $(obj)/dts/%, $(DESTDIR)$(WRAPPER_DTSDIR)/%, $(wildcard $(obj)/dts/*.dts))
+dts-installed		:= $(patsubst $(dtstree)/%, $(DESTDIR)$(WRAPPER_DTSDIR)/%, $(wildcard $(dtstree)/*.dts))
 
 all-installed		:= $(extra-installed) $(hostprogs-installed) $(wrapper-installed) $(dts-installed)
 
-- 
1.7.9.3

