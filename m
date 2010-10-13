Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0JMRkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:40:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37662 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab0JMRkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:40:00 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: jk@ozlabs.org, elendil@planet.nl, Michal Marek <mmarek@suse.cz>,
        Gilles Espinasse <g.esp@free.fr>, Jiri Kosina <jkosina@suse.cz>,
        John Saalwaechter <saalwaechter@gmail.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/package: don't break if %{_smp_mflags} isn't set
Date: Wed, 13 Oct 2010 10:39:45 -0700
Message-Id: <1286991585-4099-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same fix as in 13797b77d419fc1b16eebf2993bf7b5cea65f0bf is needed for the "new"
line invoking _smp_mflags for modules_install. Without the fix, `make
binrpm-pkg` fails with:

+ make '%{_smp_mflags}' KBUILD_SRC= modules_install
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
make[2]: *** No rule to make target `%{_smp_mflags}'.  Stop.
error: Bad exit status from /var/tmp/rpm-tmp.8S9B9e (%install)

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 scripts/package/mkspec |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 15440f5..e1c1d5b 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -70,7 +70,7 @@ echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
 echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
-echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} KBUILD_SRC= modules_install'
+echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{?_smp_mflags} KBUILD_SRC= modules_install'
 echo "%ifarch ia64"
 echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"/boot/efi/vmlinuz-$KERNELRELEASE"
 echo 'ln -s '"efi/vmlinuz-$KERNELRELEASE" '$RPM_BUILD_ROOT'"/boot/"
-- 
1.7.1

