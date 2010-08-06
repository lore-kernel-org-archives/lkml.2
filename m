Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab0HFTiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:38:18 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57794 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761971Ab0HFTiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:38:11 -0400
Date: Fri, 6 Aug 2010 20:37:56 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SELINUX: Fix build error.
Message-ID: <20100806193756.GA24645@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
  CC      security/selinux/hooks.o
/home/ralf/src/linux/linux-mips/security/selinux/hooks.c: In function ‘selinux_inode_permission’:
/home/ralf/src/linux/linux-mips/security/selinux/hooks.c:2644:38: error: ‘FILE__AUDIT_ACCESS’ undeclared (first use in this function)
/home/ralf/src/linux/linux-mips/security/selinux/hooks.c:2644:38: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [security/selinux/hooks.o] Error 1
make[3]: *** [security/selinux] Error 2
make[2]: *** [security] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

This is cause by a stale security/selinux/av_permissions.h in the $(src)
directory which will override a more recent version in $(obj) that is it
appears to strike only when building with a separate object directory.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 security/selinux/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index f013982..58d80f3 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -25,6 +25,6 @@ $(obj)/avc.o: $(obj)/flask.h
 quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
       cmd_flask = scripts/selinux/genheaders/genheaders $(obj)/flask.h $(obj)/av_permissions.h
 
-targets += flask.h
+targets += flask.h av_permissions.h
 $(obj)/flask.h: $(src)/include/classmap.h FORCE
 	$(call if_changed,flask)
