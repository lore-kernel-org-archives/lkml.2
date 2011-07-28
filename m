Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab1G1Pxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab1G1Pxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:53:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/40] UAPI: Fix drmP.h to use #include <...> when referring
 to system header files [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:52:52 +0100
Message-ID: <20110728155252.16618.84586.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix drmP.h to use #include <...> when referring to system header files to make
sure the UAPI header defaulting works correctly.  The -I flag to include/drm/
should be removed at some point.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/drm/drmP.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 6fd0f16..37d0e99 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -73,7 +73,11 @@
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <asm/pgalloc.h>
+#ifdef __KERNEL__
 #include <drm/drm.h>
+#else
+#include "drm.h"
+#endif
 
 #include <linux/idr.h>
 
@@ -83,9 +87,15 @@
 struct drm_file;
 struct drm_device;
 
+#ifdef __KERNEL__
 #include <drm/drm_os_linux.h>
 #include <drm/drm_hashtab.h>
 #include <drm/drm_mm.h>
+#else
+#include "drm_os_linux.h"
+#include "drm_hashtab.h"
+#include "drm_mm.h"
+#endif
 
 #define DRM_UT_CORE 		0x01
 #define DRM_UT_DRIVER		0x02

