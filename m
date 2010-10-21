Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0JUK3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:29:25 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:33790 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0JUK3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:29:24 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 06:29:24 EDT
Message-ID: <4CC0139E.2080106@mandriva.org>
Date: Thu, 21 Oct 2010 13:19:10 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: [PATCH] microblaze: fix build with make 3.82
Content-Type: multipart/mixed;
 boundary="------------000007050400050509070404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000007050400050509070404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


--------------000007050400050509070404
Content-Type: text/plain;
 name="microblaze-fix-build-with-make-3.82.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="microblaze-fix-build-with-make-3.82.patch"


microblaze: fix build with make 3.82

When running make headers_install_all on x86_64 and make 3.82 I hit this:

arch/microblaze/Makefile:80: *** mixed implicit and normal rules.  Stop.
make: *** [headers_install_all] Error 2

So split the rules to satisfy make 3.82.

Signed-off-by: Thomas Backlund <tmb@mandriva.org>
Cc: Stable <stable@kernel.org>

--- linux-2.6.36/arch/microblaze/Makefile.orig	2010-10-20 20:30:22.000000000 +0000
+++ linux-2.6.36/arch/microblaze/Makefile	2010-10-21 10:08:08.776564834 +0000
@@ -72,12 +72,16 @@ export MMU DTB
 
 all: linux.bin
 
-BOOT_TARGETS = linux.bin linux.bin.gz simpleImage.%
+# With make 3.82 we cannot mix normal and wildcard targets
+BOOT_TARGETS1 = linux.bin linux.bin.gz
+BOOT_TARGETS2 = simpleImage.%
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
 
-$(BOOT_TARGETS): vmlinux
+$(BOOT_TARGETS1): vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+$(BOOT_TARGETS2): vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
 
 define archhelp

--------------000007050400050509070404--
