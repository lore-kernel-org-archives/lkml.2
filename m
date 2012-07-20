Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2GTV5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:57:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab2GTV5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:57:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/13] UAPI: Refer to the DRM UAPI headers with <...> and from
 certain headers only
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, tglx@linutronix.de,
        mingo@kernel.org, davej@redhat.com
Date: Fri, 20 Jul 2012 22:56:50 +0100
Message-ID: <20120720215650.14854.75260.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only refer to the DRM UAPI headers (drm.h, drm_mode.h and drm_sarea.h) from
within drmP.h and drm_crtc.h, and use #include <...> to refer to them so that
when the UAPI split happens they can still be accessed.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Dave Airlie <airlied@redhat.com>
---

 include/drm/drmP.h     |    3 ++-
 include/drm/drm_crtc.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 31ad880..850f5ce 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -72,7 +72,8 @@
 #include <linux/workqueue.h>
 #include <linux/poll.h>
 #include <asm/pgalloc.h>
-#include "drm.h"
+#include <drm/drm.h>
+#include <drm/drm_sarea.h>
 
 #include <linux/idr.h>
 
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index bac55c2..fc820d9 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -30,6 +30,7 @@
 #include <linux/types.h>
 #include <linux/idr.h>
 #include <linux/fb.h>
+#include <drm/drm_mode.h>
 
 #include <drm/drm_fourcc.h>
 

