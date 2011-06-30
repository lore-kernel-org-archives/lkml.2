Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1F3VNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:13:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34873 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1F3VNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:13:13 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kay.sievers@vrfy.org, akpm@linux-foundation.org,
        Will Drewry <wad@chromium.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 2/2] Documentation: add pointer to name_to_dev_t for root= values
Date: Thu, 30 Jun 2011 16:10:07 -0500
Message-Id: <1309468207-24199-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309468207-24199-1-git-send-email-wad@chromium.org>
References: <1309468207-24199-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates kernel-parameters.txt to point users to the authoritative
comment for name_to_dev_t.  In addition, updates other places where some
name_to_dev_t behavior was discussed.  All other references to root=
appear to be for explicit sample usage or just side comments when
discussing other kernel parameters.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/frv/booting.txt         |   13 ++++++++++---
 Documentation/kernel-parameters.txt   |    1 +
 Documentation/m68k/kernel-options.txt |   14 ++++++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/frv/booting.txt b/Documentation/frv/booting.txt
index ace200b..37c4d84 100644
--- a/Documentation/frv/booting.txt
+++ b/Documentation/frv/booting.txt
@@ -106,13 +106,20 @@ separated by spaces:
       To use the first on-chip serial port at baud rate 115200, no parity, 8
       bits, and no flow control.
 
-  (*) root=/dev/<xxxx>
+  (*) root=<xxxx>
 
-      This specifies the device upon which the root filesystem resides. For
-      example:
+      This specifies the device upon which the root filesystem resides. It
+      may be specified by major and minor number, device path, or even
+      partition uuid, if supported.  For example:
 
 	/dev/nfs	NFS root filesystem
 	/dev/mtdblock3	Fourth RedBoot partition on the System Flash
+	PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=1
+		first partition after the partition with the given UUID
+	253:0		Device with major 253 and minor 0
+
+      Authoritative information can be found in
+      "Documentation/kernel-parameters.txt".
 
   (*) rw
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a3..c8e1737 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2234,6 +2234,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ro		[KNL] Mount root device read-only on boot
 
 	root=		[KNL] Root filesystem
+			See name_to_dev_t comment in init/do_mounts.c.
 
 	rootdelay=	[KNL] Delay (in seconds) to pause before attempting to
 			mount the root filesystem
diff --git a/Documentation/m68k/kernel-options.txt b/Documentation/m68k/kernel-options.txt
index c93bed6..97d45f2 100644
--- a/Documentation/m68k/kernel-options.txt
+++ b/Documentation/m68k/kernel-options.txt
@@ -129,6 +129,20 @@ decimal 11 is the major of SCSI CD-ROMs, and the minor 0 stands for
 the first of these. You can find out all valid major numbers by
 looking into include/linux/major.h.
 
+In addition to major and minor numbers, if the device containing your
+root partition uses a partition table format with unique partition
+identifiers, then you may use them.  For instance,
+"root=PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF".  It is also
+possible to reference another partition on the same device using a
+known partition UUID as the starting point.  For example,
+if partition 5 of the device has the UUID of
+00112233-4455-6677-8899-AABBCCDDEEFF then partition 3 may be found as
+follows:
+  PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=-2
+
+Authoritative information can be found in
+"Documentation/kernel-parameters.txt".
+
 
 2.2) ro, rw
 -----------
-- 
1.7.0.4

