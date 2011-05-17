Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1EQRhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:37:54 -0400
Received: from outmail020.snc4.facebook.com ([66.220.144.152]:61409 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755995Ab1EQRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:37:49 -0400
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 3/6] kbuild: Create a kernel-headers RPM
Date: Tue, 17 May 2011 10:36:16 -0700
Message-Id: <1305653779-3445-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1305653779-3445-1-git-send-email-asharma@fb.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To compile binaries which depend on new kernel interfaces, we need a
kernel-headers RPM

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 scripts/package/mkspec |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 81b6057..c38e950 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -55,6 +55,17 @@ echo "%description -n kernel-devel"
 echo "This package provides kernel headers and makefiles sufficient to build modules"
 echo "against the $__KERNELRELEASE kernel package."
 echo ""
+echo "%package headers"
+echo "Summary: Header files for the Linux kernel for use by glibc"
+echo "Group: Development/System"
+echo "Obsoletes: kernel-headers"
+echo "Provides: kernel-headers = %{version}"
+echo "%description headers"
+echo "Kernel-headers includes the C header files that specify the interface"
+echo "between the Linux kernel and userspace libraries and programs.  The"
+echo "header files define structures and constants that are needed for"
+echo "building most standard programs and are also needed for rebuilding the"
+echo "glibc package."
 
 if ! $PREBUILT; then
 echo "%prep"
@@ -91,6 +102,7 @@ echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"/boot/vmlinuz-$KERNELRELEASE"
 echo "%endif"
 echo "%endif"
 
+echo 'make %{?_smp_mflags} INSTALL_HDR_PATH=$RPM_BUILD_ROOT/usr headers_install'
 echo 'cp System.map $RPM_BUILD_ROOT'"/boot/System.map-$KERNELRELEASE"
 
 echo 'cp .config $RPM_BUILD_ROOT'"/boot/config-$KERNELRELEASE"
@@ -130,3 +142,7 @@ echo "%files devel"
 echo '%defattr (-, root, root)'
 echo "/usr/src/kernels/$KERNELRELEASE"
 echo ""
+echo "%files headers"
+echo '%defattr (-, root, root)'
+echo "/usr/include"
+echo ""
-- 
1.7.4

