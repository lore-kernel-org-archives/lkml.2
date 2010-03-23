Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0CWAcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, dri-devel@lists.sourceforge.net
Subject: [PATCH 11/18] i915: Provide config option for enabling tracepoints
Date: Tue, 23 Mar 2010 01:32:13 +0100
Message-Id: <1269304340-25372-12-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: dri-devel@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/gpu/drm/Kconfig           |    9 +++++++++
 drivers/gpu/drm/i915/i915_trace.h |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..bce8013 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -124,6 +124,15 @@ config DRM_I915_KMS
 	  the driver to bind to PCI devices, which precludes loading things
 	  like intelfb.
 
+config DRM_I915_TRACER
+	bool "Enable tracing of i915 driver"
+	depends on DRM_I915 && EVENT_TRACING
+	help
+	  Say Y here to make i915 driver provide trace points in functions
+	  handling irqs, dmas, and gem.
+
+	  If unsure, say N.
+
 endchoice
 
 config DRM_MGA
diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 01840d9..fdb59c2 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -3,6 +3,8 @@
 
 #include <linux/stringify.h>
 #include <linux/types.h>
+#undef TRACE_CONFIG
+#define TRACE_CONFIG CONFIG_DRM_I915_TRACER
 #include <linux/tracepoint.h>
 
 #include <drm/drmP.h>
-- 
1.6.4.2

