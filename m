Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2K2RVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:21:43 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35135 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2K2RVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:21:40 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Peter Foley <pefoley2@verizon.net>, Adam Lee <adam8157@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 1/1] kbuild: solve the DSO link change issue
Date: Thu, 29 Nov 2012 17:21:28 +0000
Message-Id: <1354209688-16247-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when make menuconfig, it reports this error:

/usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: undefined reference to symbol 'acs_map'
/usr/bin/ld: note: 'acs_map' is defined in DSO /lib64/libtinfo.so.5 so try adding it to the linker command line
/lib64/libtinfo.so.5: could not read symbols: Invalid operation
collect2: ld returned 1 exit status

due to the DSO link change, we must explicitly link against every library needed.
http://fedoraproject.org/wiki/UnderstandingDSOLinkChange

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 scripts/kconfig/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3091794..ae339a1 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -215,6 +215,7 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -Wno-missing-prototypes
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
+HOSTLOADLIBES_mconf += -ltinfo
 
 HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
-- 
1.7.4.5

