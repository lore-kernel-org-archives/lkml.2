Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2CNHof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:44:35 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:40993
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961Ab2CNHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:44:33 -0400
X-Greylist: delayed 1093 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2012 03:44:33 EDT
Date: Wed, 14 Mar 2012 03:26:07 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
To: arnd@arndb.de, davem@davemloft.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: [PATCH] Install kernel-page-flags.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Programs using /proc/kpageflags need to know about the various flags.  The
<linux/kernel-page-flags.h> provides them and the comments in the file
indicate that it is supposed to be used by user-level code.  But the file
is not installed.

The patch below installs the headers and marks the unstable flags as
out-of-bounds.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 include/linux/Kbuild              |    1 +
 include/linux/kernel-page-flags.h |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index c94e717..356928e 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -227,6 +227,7 @@ header-y += kd.h
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index bd92a89..096b05d 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -31,6 +31,8 @@
 
 #define KPF_KSM			21
 
+#ifdef __KERNEL__
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -43,4 +45,6 @@
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
 
+#endif /* __KERNEL__ */
+
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
