Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0EXIXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:23:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0EXIXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:23:32 -0400
Message-ID: <4BFA3808.5080203@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:25:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: airlied@linux.ie, chris@chris-wilson.co.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: [PATCH] drm/i915: Convert more trace events to DEFINE_EVENT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert i915_gem_object_clflush to DEFINE_EVENT, and save ~0.5K:

   text    data     bss     dec     hex filename
  13204    2732      12   15948    3e4c i915_trace_points.o.orig
  12668    2732      12   15412    3c34 i915_trace_points.o

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/gpu/drm/i915/i915_trace.h |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_trace.h b/drivers/gpu/drm/i915/i915_trace.h
index 9e4c45f..fab2176 100644
--- a/drivers/gpu/drm/i915/i915_trace.h
+++ b/drivers/gpu/drm/i915/i915_trace.h
@@ -53,23 +53,6 @@ TRACE_EVENT(i915_gem_object_bind,
 		      __entry->obj, __entry->gtt_offset)
 );
 
-TRACE_EVENT(i915_gem_object_clflush,
-
-	    TP_PROTO(struct drm_gem_object *obj),
-
-	    TP_ARGS(obj),
-
-	    TP_STRUCT__entry(
-			     __field(struct drm_gem_object *, obj)
-			     ),
-
-	    TP_fast_assign(
-			   __entry->obj = obj;
-			   ),
-
-	    TP_printk("obj=%p", __entry->obj)
-);
-
 TRACE_EVENT(i915_gem_object_change_domain,
 
 	    TP_PROTO(struct drm_gem_object *obj, uint32_t old_read_domains, uint32_t old_write_domain),
@@ -132,6 +115,13 @@ DECLARE_EVENT_CLASS(i915_gem_object,
 	    TP_printk("obj=%p", __entry->obj)
 );
 
+DEFINE_EVENT(i915_gem_object, i915_gem_object_clflush,
+
+	    TP_PROTO(struct drm_gem_object *obj),
+
+	    TP_ARGS(obj)
+);
+
 DEFINE_EVENT(i915_gem_object, i915_gem_object_unbind,
 
 	    TP_PROTO(struct drm_gem_object *obj),
-- 
1.6.3

