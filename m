Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab2KRPBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 10:01:16 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:48059 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2KRPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 10:01:15 -0500
Message-ID: <50A8F837.7040700@acm.org>
Date: Sun, 18 Nov 2012 16:01:11 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Richard Weinberger <richard@nod.at>, Michal Marek <mmarek@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: Unbreak cleaning external module build directory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid that "$(MAKE) -C $(KDIR) M=$(PWD) clean" triggers the following
error message when invoked from inside the Makefile of an external
kernel module:

rm: cannot remove 'System.map': Permission denied
make[1]: *** [clean] Error 1

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9f6ca12..46b9be5 100644
--- a/Makefile
+++ b/Makefile
@@ -1252,7 +1252,7 @@ scripts: ;
 endif # KBUILD_EXTMOD
 
 clean: $(clean-dirs)
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
+	$(Q)$(if $(KBUILD_EXTMOD),,$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
 	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
-- 
1.7.10.4

