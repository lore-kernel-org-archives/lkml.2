Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2JINuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2JINuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:50:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: JBottomley@parallels.com
cc: dhowells@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH/GIT PULL] UAPI: (Scripted) Disintegrate include/scsi
Date: Tue, 09 Oct 2012 14:50:11 +0100
Message-ID: <31138.1349790611@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This completes part of the Userspace API (UAPI) disintegration for which the
preparatory patches were pulled recently.  After these patches, userspace
headers will be segregated into:

	include/uapi/linux/.../foo.h

for the userspace interface stuff, and:

	include/linux/.../foo.h

for the strictly kernel internal stuff.

This patch can be pulled from:

	git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-scsi-20121009

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Dave Jones <davej@redhat.com>
---
diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index f2b9491..562ff9d 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -1,4 +1 @@
-header-y += scsi_netlink.h
-header-y += scsi_netlink_fc.h
-header-y += scsi_bsg_fc.h
 header-y += fc/
diff --git a/include/uapi/scsi/Kbuild b/include/uapi/scsi/Kbuild
index 29a87dd..75746d5 100644
--- a/include/uapi/scsi/Kbuild
+++ b/include/uapi/scsi/Kbuild
@@ -1,2 +1,5 @@
 # UAPI Header export list
 header-y += fc/
+header-y += scsi_bsg_fc.h
+header-y += scsi_netlink.h
+header-y += scsi_netlink_fc.h
diff --git a/include/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
similarity index 100%
rename from include/scsi/scsi_bsg_fc.h
rename to include/uapi/scsi/scsi_bsg_fc.h
diff --git a/include/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_netlink.h
similarity index 100%
rename from include/scsi/scsi_netlink.h
rename to include/uapi/scsi/scsi_netlink.h
diff --git a/include/scsi/scsi_netlink_fc.h b/include/uapi/scsi/scsi_netlink_fc.h
similarity index 100%
rename from include/scsi/scsi_netlink_fc.h
rename to include/uapi/scsi/scsi_netlink_fc.h
