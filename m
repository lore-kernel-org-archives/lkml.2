Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2D2OFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 10:05:38 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:41954
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab2D2OFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 10:05:37 -0400
Date: Sun, 29 Apr 2012 10:04:57 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201204291404.q3TE4vfN023826@drepperk.user.openhosting.com>
To: arnd@arndb.de, davem@davemloft.net, hch@infradead.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Subject: [PATCH] [RESEND] Install kernel-page-flags.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No one has definitely commented on this patch nor is it applied.  Christoph at first said it shouldn't be done but I think he had to retract his objection.  The interface is already out there.  It's also IMO the right choice to go with a binary interface since there is so much data involved and the format is not tied directly to kernel-internal data structures.

Could either the patch please be applied or a reason given why not?


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 include/linux/Kbuild              |    1 +
 include/linux/kernel-page-flags.h |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3c9b616..50f55c7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -227,6 +227,7 @@
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index 26a6571..a1bdf69 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -32,6 +32,8 @@
 #define KPF_KSM			21
 #define KPF_THP			22
 
+#ifdef __KERNEL__
+
 /* kernel hacking assistances
  * WARNING: subject to change, never rely on them!
  */
@@ -44,4 +46,6 @@
 #define KPF_ARCH		38
 #define KPF_UNCACHED		39
 
+#endif /* __KERNEL__ */
+
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
