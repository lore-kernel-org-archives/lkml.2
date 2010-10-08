Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab0JHBwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 21:52:15 -0400
Received: from [203.94.56.252] ([203.94.56.252]:43995 "EHLO
	atomos.dmz.longlandclan.yi.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab0JHBwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 21:52:14 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 21:52:13 EDT
X-Spam-Check-By: atomos.dmz.longlandclan.yi.org
From: Stuart Longland <redhatter@gentoo.org>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [RFC MIPS] Update buildtar for MIPS
Date: Fri,  8 Oct 2010 11:45:37 +1000
Message-Id: <1286502337-23882-1-git-send-email-redhatter@gentoo.org>
X-Mailer: git-send-email 1.7.1
To: linux-mips@linux-mips.org
X-Virus-Checked: Checked by ClamAV on atomos.dmz.longlandclan.yi.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of 64-bit systems supported by Linux/MIPS have boot firmware or
bootloaders that only understand 32-bit ELF files, and as such, the vmlinux.32
target exists to support these systems.  Therefore, it'd be nice if the tar-pkg
target recognised this, and included the right version when packaging up a
binary of the kernel.

This updates buildtar to support MIPS targets.  MIPS may use 'vmlinux'
or 'vmlinux.32' depending on the target system.  This uses 'vmlinux.32'
in preference to 'vmlinux' where present (although I should check which
is newer), including either file as /boot/vmlinux-${version}.
---
 scripts/package/buildtar |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 51b2aa0..988c3bd 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -83,6 +83,13 @@ case "${ARCH}" in
 		[ -f "${objtree}/vmlinux.SYS" ] && cp -v -- "${objtree}/vmlinux.SYS" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}.SYS"
 		[ -f "${objtree}/vmlinux.dsk" ] && cp -v -- "${objtree}/vmlinux.dsk" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}.dsk"
 		;;
+	mips)
+		if [ -f "${objtree}/vmlinux.32" ] ; then
+			cp -v -- "${objtree}/vmlinux.32" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		elif [ -f "${objtree}/vmlinux" ] ; then
+			cp -v -- "${objtree}/vmlinux" "${tmpdir}/boot/vmlinux-${KERNELRELEASE}"
+		fi
+		;;
 	*)
 		[ -f "${KBUILD_IMAGE}" ] && cp -v -- "${KBUILD_IMAGE}" "${tmpdir}/boot/vmlinux-kbuild-${KERNELRELEASE}"
 		echo "" >&2
-- 
1.7.1

