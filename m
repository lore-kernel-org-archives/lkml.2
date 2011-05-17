Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1EQRh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:37:57 -0400
Received: from outmail009.snc4.facebook.com ([66.220.144.141]:37899 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756018Ab1EQRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:37:50 -0400
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 4/6] kbuild: Move firmware images to a separate RPM
Date: Tue, 17 May 2011 10:36:17 -0700
Message-Id: <1305653779-3445-4-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1305653779-3445-1-git-send-email-asharma@fb.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows multiple kernel RPMs to be installed without
namespace conflicts.

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 scripts/package/mkspec |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index c38e950..bf215c5 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -66,6 +66,13 @@ echo "between the Linux kernel and userspace libraries and programs.  The"
 echo "header files define structures and constants that are needed for"
 echo "building most standard programs and are also needed for rebuilding the"
 echo "glibc package."
+echo ""
+echo "%package firmware"
+echo "Summary: Set of firmware images in the kernel tree"
+echo "Group: Development/System"
+echo "%description firmware"
+echo "Firmware images in the kernel tree provided for backward compability"
+echo ""
 
 if ! $PREBUILT; then
 echo "%prep"
@@ -90,6 +97,7 @@ echo 'mkdir -p $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"
 
 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{?_smp_mflags} KBUILD_SRC= modules_install'
+echo 'make %{?_smp_mflags} INSTALL_FW_PATH=$RPM_BUILD_ROOT/lib/firmware KBUILD_SRC= firmware_install'
 echo "%ifarch ia64"
 echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"/boot/efi/vmlinuz-$KERNELRELEASE"
 echo 'ln -s '"efi/vmlinuz-$KERNELRELEASE" '$RPM_BUILD_ROOT'"/boot/"
@@ -135,7 +143,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
-echo "/lib/firmware"
 echo "/boot/*"
 echo ""
 echo "%files devel"
@@ -146,3 +153,7 @@ echo "%files headers"
 echo '%defattr (-, root, root)'
 echo "/usr/include"
 echo ""
+echo "%files firmware"
+echo '%defattr (-, root, root)'
+echo "/lib/firmware"
+echo ""
-- 
1.7.4

