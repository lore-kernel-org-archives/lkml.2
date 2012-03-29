Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab2C2PBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:01:10 -0400
Received: from pmx.elettra.trieste.it ([140.105.206.203]:55844 "EHLO
	pmx.elettra.trieste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab2C2PBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:01:03 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2012 11:01:03 EDT
From: Alessio Igor Bogani <abogani@kernel.org>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Rowand Frank <Frank_Rowand@sonyusa.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <Tim.Bird@am.sony.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] Let modpost parses vmlinux instead of vmlinux.o
Date: Thu, 29 Mar 2012 16:53:06 +0200
Message-Id: <1333032786-12457-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4F737193.4030709@am.sony.com>
References: <4F737193.4030709@am.sony.com>
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.3.29.143916
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_NAME_PHRASE 0, NO_URI_FOUND 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MULTIPLE_RCPTS_CC_X2 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Rowand,

What do you think about this patch?
Thanks!

Ciao,
Alessio

---
 Makefile                 |    2 +-
 scripts/Makefile.modpost |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 123d858..b589d1f 100644
--- a/Makefile
+++ b/Makefile
@@ -876,7 +876,7 @@ quiet_cmd_vmlinux-modpost = LD      $@
 define rule_vmlinux-modpost
 	:
 	+$(call cmd,vmlinux-modpost)
-	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $*
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
 endef
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 56dfafc..ca0db29 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -93,7 +93,7 @@ __modpost: $(modules:.ko=.o) FORCE
 quiet_cmd_kernel-mod = MODPOST $@
       cmd_kernel-mod = $(modpost) $@
 
-vmlinux.o: FORCE
+vmlinux vmlinux.o: FORCE
 	$(call cmd,kernel-mod)
 
 # Declare generated files as targets for modpost
-- 
1.7.5.4

