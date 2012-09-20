Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2ITO2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:28:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab2ITO2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:28:51 -0400
Message-ID: <505B281D.80405@suse.de>
Date: Thu, 20 Sep 2012 10:28:45 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/kbuild: archscripts depends on scripts_basic
References: <505A02F8.4040804@suse.de> <505A03EC.8090502@linux.intel.com>
In-Reply-To: <505A03EC.8090502@linux.intel.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While building the SUSE kernel packages, which build the scripts,
make clean, and then build everything, we have been running into spurious
build failures. We tracked them down to a simple dependency issue:

$ make mrproper
  CLEAN   arch/x86/tools
  CLEAN   scripts/basic
$ cp patches/config/x86_64/desktop .config
$ make archscripts
  HOSTCC  arch/x86/tools/relocs
/bin/sh: scripts/basic/fixdep: No such file or directory
make[3]: *** [arch/x86/tools/relocs] Error 1
make[2]: *** [archscripts] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

This was introduced by commit
6520fe55 (x86, realmode: 16-bit real-mode code support for relocs),
which added the archscripts dependency to archprepare.

This patch adds the scripts_basic dependency to the x86 archscripts.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -142,7 +142,7 @@ KBUILD_CFLAGS += $(call cc-option,-mno-a
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)
 
-archscripts:
+archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
 
 ###

