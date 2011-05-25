Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1EYUep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:34:45 -0400
Received: from outmail006.snc4.facebook.com ([66.220.144.138]:36272 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755701Ab1EYUem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:34:42 -0400
Date: Wed, 25 May 2011 13:34:41 -0700
From: Arun Sharma <asharma@fb.com>
To: Arun Sharma <asharma@fb.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] kbuild: Add a kernel-devel package
Message-ID: <20110525203441.GA30980@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <1305653779-3445-2-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305653779-3445-2-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Updated version of this patch. ]

    kbuild: Add a kernel-devel package
    
    Useful for building modules without having kernel sources
    
    Signed-off-by: Arun Sharma <asharma@fb.com>

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index f5f0cb5..c79b777 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -49,6 +49,14 @@ echo ""
 echo "%description"
 echo "The Linux Kernel, the operating system core itself"
 echo ""
+echo "%package devel"
+echo "Summary: Development package for building kernel modules to match the $__KERNELRELEASE kernel"
+echo "Group: System Environment/Kernel"
+echo "AutoReqProv: no"
+echo "%description -n kernel-devel"
+echo "This package provides kernel headers and makefiles sufficient to build modules"
+echo "against the $__KERNELRELEASE kernel package."
+echo ""
 
 if ! $PREBUILT; then
 echo "%prep"
@@ -96,6 +104,11 @@ echo 'mv vmlinux.bz2 $RPM_BUILD_ROOT'"/boot/vmlinux-$KERNELRELEASE.bz2"
 echo 'mv vmlinux.orig vmlinux'
 echo "%endif"
 
+echo 'rm -rf $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE/{build,source}"
+echo "mkdir -p "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE"
+echo "rsync -avz --exclude '.git/' --exclude '*vmlinux*' --exclude '.*' --exclude '*.o' --exclude '*.so' --exclude '*.ko' . "'$RPM_BUILD_ROOT'"/usr/src/kernels/$KERNELRELEASE/"
+echo 'pushd $RPM_BUILD_ROOT'"/lib/modules/$KERNELRELEASE"' && ln -s build source && ln -s '"/usr/src/kernels/$KERNELRELEASE"' build && popd'
+
 echo ""
 echo "%preun"
 echo '/sbin/new-kernel-pkg --rminitrd --rmmoddep --remove '"$KERNELRELEASE"' || exit $?'
@@ -115,3 +128,7 @@ echo "/lib/modules/$KERNELRELEASE"
 echo "/lib/firmware"
 echo "/boot/*"
 echo ""
+echo "%files devel"
+echo '%defattr (-, root, root)'
+echo "/usr/src/kernels/$KERNELRELEASE"
+echo ""
