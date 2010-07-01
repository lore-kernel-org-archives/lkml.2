Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab0GAVgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:36:01 -0400
Received: from kroah.org ([198.145.64.141]:33040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759221Ab0GAVOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:48 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:58 2010
Message-Id: <20100701174258.769447197@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <device@lanana.org>
Subject: [146/200] misc: Fix allocation borrowed by vhost_net
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 79907d89c397b8bc2e05b347ec94e928ea919d33 upstream.

10, 233 is allocated officially to /dev/kmview which is shipping in
Ubuntu and Debian distributions.  vhost_net seem to have borrowed it
without making a proper request and this causes regressions in the other
distributions.

vhost_net can use a dynamic minor so use that instead.  Also update the
file with a comment to try and avoid future misunderstandings.

Signed-off-by: Alan Cox <device@lanana.org>
[ We should have caught this before 2.6.34 got released.  - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/vhost/net.c        |    2 +-
 include/linux/miscdevice.h |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -637,7 +637,7 @@ const static struct file_operations vhos
 };
 
 static struct miscdevice vhost_net_misc = {
-	VHOST_NET_MINOR,
+	MISC_DYNAMIC_MINOR,
 	"vhost-net",
 	&vhost_net_fops,
 };
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -3,6 +3,12 @@
 #include <linux/module.h>
 #include <linux/major.h>
 
+/*
+ *	These allocations are managed by device@lanana.org. If you use an
+ *	entry that is not in assigned your entry may well be moved and
+ *	reassigned, or set dynamic if a fixed value is not justified.
+ */
+
 #define PSMOUSE_MINOR		1
 #define MS_BUSMOUSE_MINOR	2
 #define ATIXL_BUSMOUSE_MINOR	3
@@ -30,7 +36,6 @@
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
-#define VHOST_NET_MINOR		233
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;


