Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab0HPIHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 04:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0HPIG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 04:06:59 -0400
From: Jon Masters <jcm@jonmasters.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@jonmasters.org>
Subject: [PATCH] modules: don't call depmod when overriding external module install path
Date: Mon, 16 Aug 2010 04:03:34 -0400
Message-Id: <1281945814-9720-1-git-send-email-jcm@jonmasters.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent kernels include an additional call to depmod during the installation
of external kernel modules as a convenience, in order to ensure that those
modules are picked up by the module loading tools/initramfs scripts, etc.
Although this call is potentially of some value, it should not be made
when explicitly setting INSTALL_MOD_PATH to a different location. This
avoids creating extraneous modules.* files that will never be used.

Signed-off-by: Jon Masters <jcm@jonmasters.org>
---
 Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index f3bdff8..2b904f2 100644
--- a/Makefile
+++ b/Makefile
@@ -1325,7 +1325,9 @@ _emodinst_:
 
 PHONY += _emodinst_post
 _emodinst_post: _emodinst_
+ifeq ($(INSTALL_MOD_PATH),)
 	$(call cmd,depmod)
+endif
 
 clean-dirs := $(addprefix _clean_,$(KBUILD_EXTMOD))
 
-- 
1.7.2.1

