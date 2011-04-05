Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1DEPG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:06:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1DEO7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:34 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 03/34] powerpc: Call gzip with -n
Date: Tue,  5 Apr 2011 16:58:50 +0200
Message-Id: <1302015561-21047-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timestamps recorded in the .gz files add no value.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/powerpc/boot/wrapper |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index cb97e75..854797b 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -251,7 +251,7 @@ if [ -z "$cacheit" -o ! -f "$vmz$gzip" -o "$vmz$gzip" -ot "$kernel" ]; then
     ${CROSS}objcopy $objflags "$kernel" "$vmz.$$"
 
     if [ -n "$gzip" ]; then
-        gzip -f -9 "$vmz.$$"
+        gzip -n -f -9 "$vmz.$$"
     fi
 
     if [ -n "$cacheit" ]; then
@@ -336,7 +336,7 @@ coff)
     $objbin/hack-coff "$ofile"
     ;;
 cuboot*)
-    gzip -f -9 "$ofile"
+    gzip -n -f -9 "$ofile"
     ${MKIMAGE} -A ppc -O linux -T kernel -C gzip -a "$base" -e "$entry" \
             $uboot_version -d "$ofile".gz "$ofile"
     ;;
@@ -383,6 +383,6 @@ ps3)
 
     odir="$(dirname "$ofile.bin")"
     rm -f "$odir/otheros.bld"
-    gzip --force -9 --stdout "$ofile.bin" > "$odir/otheros.bld"
+    gzip -n --force -9 --stdout "$ofile.bin" > "$odir/otheros.bld"
     ;;
 esac
-- 
1.7.4.1

