Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761851Ab2FHFM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:12:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43341 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761455Ab2FHFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:31 -0400
Message-Id: <20120608041851.812884261@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:20:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ulrich Drepper <drepper@akkadia.org>,
        Ulrich Drepper <drepper@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [ 81/82] kbuild: install kernel-page-flags.h
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulrich Drepper <drepper@akkadia.org>

commit 9295b7a07c859a42346221b5839be0ae612333b0 upstream.

Programs using /proc/kpageflags need to know about the various flags.  The
<linux/kernel-page-flags.h> provides them and the comments in the file
indicate that it is supposed to be used by user-level code.  But the file
is not installed.

Install the headers and mark the unstable flags as out-of-bounds.  The
page-type tool is also adjusted to not duplicate the definitions

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context; drop change to missing tools/vm/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -224,6 +224,7 @@
 header-y += kdev_t.h
 header-y += kernel.h
 header-y += kernelcapi.h
+header-y += kernel-page-flags.h
 header-y += keyboard.h
 header-y += keyctl.h
 header-y += l2tp.h
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


