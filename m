Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0HNLaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 07:30:03 -0400
Received: from odpn1.odpn.net ([212.40.96.53]:50983 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab0HNLaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 07:30:02 -0400
X-Greylist: delayed 1097 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 07:30:02 EDT
From: "Gabor Z. Papp" <gzp@papp.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re:2.6.27.52 stable review
References: <20100813214704.GA18960@kroah.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
Date: Sat, 14 Aug 2010 13:11:43 +0200
Message-ID: <x6r5i1o3dc@gzp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

* Greg KH <gregkh@suse.de>:

| If I could get some people to please test this -rc release?

BTW seems like 2.6.27 no more combatible with GNU Make 3.82:

$ make oldconfig
Makefile:443: *** mixed implicit and normal rules.  Stop.

Same with line 1609.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=Makefile.diff

--- Makefile.orig	2010-08-13 23:02:40.000000000 +0200
+++ Makefile	2010-08-14 13:10:00.650815242 +0200
@@ -440,7 +440,11 @@
 include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG
 
-config %config: scripts_basic outputmakefile FORCE
+config: scripts_basic outputmakefile FORCE
+	$(Q)mkdir -p include/linux include/config
+	$(Q)$(MAKE) $(build)=scripts/kconfig $@
+
+%config: scripts_basic outputmakefile FORCE
 	$(Q)mkdir -p include/linux include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
@@ -1602,7 +1606,11 @@
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 
 # Modules
-/ %/: prepare scripts FORCE
+/: prepare scripts FORCE
+	$(cmd_crmodverdir)
+	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
+	$(build)=$(build-dir)
+%/: prepare scripts FORCE
 	$(cmd_crmodverdir)
 	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
 	$(build)=$(build-dir)

--=-=-=--
