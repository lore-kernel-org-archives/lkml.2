Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1EDNdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:33:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48290 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752128Ab1EDNdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:33:07 -0400
Date: Wed, 4 May 2011 09:33:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC patch 25/32] trace event video gpu remove semicolons
Message-ID: <20110504133304.GB10439@Krystal>
References: <20110503231023.968960757@efficios.com> <20110503231428.245701713@efficios.com> <20110503172141.7d06fd7d@jbarnes-desktop> <20110504015147.GB3165@Krystal> <BANLkTinJAeFY5fFOprvvj2nSkN8cKfGvXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinJAeFY5fFOprvvj2nSkN8cKfGvXA@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:29:48 up 161 days, 18:32,  5 users,  load average: 0.06, 0.05,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jean Pihet (jean.pihet@newoldbits.com) wrote:
[...]
> There are radeon specific trace points defined in
> drivers/gpu/drm/radeon/radeon_trace.h, which are not covered by this
> patch.
> Is it intentional?

No, it's not intentional. Here is the updated patch. Thanks for spotting
this! Please note that the current "Reviewed-by: Jesse Barnes" only
apply to the drm_trace.h and i915_trace.h portion of the patch.

Mathieu

trace event video gpu remove semicolons

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

* Changelog
- Take care of radeon_trace.h

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Airlie <airlied@redhat.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Jean Pihet <jean.pihet@newoldbits.com>
---
 drivers/gpu/drm/drm_trace.h           |    6 +--
 drivers/gpu/drm/i915/i915_trace.h     |   52 +++++++++++++++++-----------------
 drivers/gpu/drm/radeon/radeon_trace.h |   12 +++----
 3 files changed, 35 insertions(+), 35 deletions(-)

Index: linux-2.6-lttng/drivers/gpu/drm/drm_trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/gpu/drm/drm_trace.h
+++ linux-2.6-lttng/drivers/gpu/drm/drm_trace.h
@@ -22,7 +22,7 @@ TRACE_EVENT(drm_vblank_event,
 		    __entry->seq = seq;
 		    ),
 	    TP_printk("crtc=%d, seq=%d", __entry->crtc, __entry->seq)
-);
+)
 
 TRACE_EVENT(drm_vblank_event_queued,
 	    TP_PROTO(pid_t pid, int crtc, unsigned int seq),
@@ -39,7 +39,7 @@ TRACE_EVENT(drm_vblank_event_queued,
 		    ),
 	    TP_printk("pid=%d, crtc=%d, seq=%d", __entry->pid, __entry->crtc, \
 		      __entry->seq)
-);
+)
 
 TRACE_EVENT(drm_vblank_event_delivered,
 	    TP_PROTO(pid_t pid, int crtc, unsigned int seq),
@@ -56,7 +56,7 @@ TRACE_EVENT(drm_vblank_event_delivered,
 		    ),
 	    TP_printk("pid=%d, crtc=%d, seq=%d", __entry->pid, __entry->crtc, \
 		      __entry->seq)
-);
+)
 
 #endif /* _DRM_TRACE_H_ */
 
Index: linux-2.6-lttng/drivers/gpu/drm/i915/i915_trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/gpu/drm/i915/i915_trace.h
+++ linux-2.6-lttng/drivers/gpu/drm/i915/i915_trace.h
@@ -31,7 +31,7 @@ TRACE_EVENT(i915_gem_object_create,
 			   ),
 
 	    TP_printk("obj=%p, size=%u", __entry->obj, __entry->size)
-);
+)
 
 TRACE_EVENT(i915_gem_object_bind,
 	    TP_PROTO(struct drm_i915_gem_object *obj, bool mappable),
@@ -54,7 +54,7 @@ TRACE_EVENT(i915_gem_object_bind,
 	    TP_printk("obj=%p, offset=%08x size=%x%s",
 		      __entry->obj, __entry->offset, __entry->size,
 		      __entry->mappable ? ", mappable" : "")
-);
+)
 
 TRACE_EVENT(i915_gem_object_unbind,
 	    TP_PROTO(struct drm_i915_gem_object *obj),
@@ -74,7 +74,7 @@ TRACE_EVENT(i915_gem_object_unbind,
 
 	    TP_printk("obj=%p, offset=%08x size=%x",
 		      __entry->obj, __entry->offset, __entry->size)
-);
+)
 
 TRACE_EVENT(i915_gem_object_change_domain,
 	    TP_PROTO(struct drm_i915_gem_object *obj, u32 old_read, u32 old_write),
@@ -98,7 +98,7 @@ TRACE_EVENT(i915_gem_object_change_domai
 		      __entry->read_domains & 0xffff,
 		      __entry->write_domain >> 16,
 		      __entry->write_domain & 0xffff)
-);
+)
 
 TRACE_EVENT(i915_gem_object_pwrite,
 	    TP_PROTO(struct drm_i915_gem_object *obj, u32 offset, u32 len),
@@ -118,7 +118,7 @@ TRACE_EVENT(i915_gem_object_pwrite,
 
 	    TP_printk("obj=%p, offset=%u, len=%u",
 		      __entry->obj, __entry->offset, __entry->len)
-);
+)
 
 TRACE_EVENT(i915_gem_object_pread,
 	    TP_PROTO(struct drm_i915_gem_object *obj, u32 offset, u32 len),
@@ -138,7 +138,7 @@ TRACE_EVENT(i915_gem_object_pread,
 
 	    TP_printk("obj=%p, offset=%u, len=%u",
 		      __entry->obj, __entry->offset, __entry->len)
-);
+)
 
 TRACE_EVENT(i915_gem_object_fault,
 	    TP_PROTO(struct drm_i915_gem_object *obj, u32 index, bool gtt, bool write),
@@ -163,7 +163,7 @@ TRACE_EVENT(i915_gem_object_fault,
 		      __entry->gtt ? "GTT" : "CPU",
 		      __entry->index,
 		      __entry->write ? ", writable" : "")
-);
+)
 
 DECLARE_EVENT_CLASS(i915_gem_object,
 	    TP_PROTO(struct drm_i915_gem_object *obj),
@@ -178,17 +178,17 @@ DECLARE_EVENT_CLASS(i915_gem_object,
 			   ),
 
 	    TP_printk("obj=%p", __entry->obj)
-);
+)
 
 DEFINE_EVENT(i915_gem_object, i915_gem_object_clflush,
 	     TP_PROTO(struct drm_i915_gem_object *obj),
 	     TP_ARGS(obj)
-);
+)
 
 DEFINE_EVENT(i915_gem_object, i915_gem_object_destroy,
 	    TP_PROTO(struct drm_i915_gem_object *obj),
 	    TP_ARGS(obj)
-);
+)
 
 TRACE_EVENT(i915_gem_evict,
 	    TP_PROTO(struct drm_device *dev, u32 size, u32 align, bool mappable),
@@ -211,7 +211,7 @@ TRACE_EVENT(i915_gem_evict,
 	    TP_printk("dev=%d, size=%d, align=%d %s",
 		      __entry->dev, __entry->size, __entry->align,
 		      __entry->mappable ? ", mappable" : "")
-);
+)
 
 TRACE_EVENT(i915_gem_evict_everything,
 	    TP_PROTO(struct drm_device *dev, bool purgeable),
@@ -230,7 +230,7 @@ TRACE_EVENT(i915_gem_evict_everything,
 	    TP_printk("dev=%d%s",
 		      __entry->dev,
 		      __entry->purgeable ? ", purgeable only" : "")
-);
+)
 
 TRACE_EVENT(i915_gem_ring_dispatch,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
@@ -251,7 +251,7 @@ TRACE_EVENT(i915_gem_ring_dispatch,
 
 	    TP_printk("dev=%u, ring=%u, seqno=%u",
 		      __entry->dev, __entry->ring, __entry->seqno)
-);
+)
 
 TRACE_EVENT(i915_gem_ring_flush,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 invalidate, u32 flush),
@@ -274,7 +274,7 @@ TRACE_EVENT(i915_gem_ring_flush,
 	    TP_printk("dev=%u, ring=%x, invalidate=%04x, flush=%04x",
 		      __entry->dev, __entry->ring,
 		      __entry->invalidate, __entry->flush)
-);
+)
 
 DECLARE_EVENT_CLASS(i915_gem_request,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
@@ -294,32 +294,32 @@ DECLARE_EVENT_CLASS(i915_gem_request,
 
 	    TP_printk("dev=%u, ring=%u, seqno=%u",
 		      __entry->dev, __entry->ring, __entry->seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_add,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
 	    TP_ARGS(ring, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_complete,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
 	    TP_ARGS(ring, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_retire,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
 	    TP_ARGS(ring, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_begin,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
 	    TP_ARGS(ring, seqno)
-);
+)
 
 DEFINE_EVENT(i915_gem_request, i915_gem_request_wait_end,
 	    TP_PROTO(struct intel_ring_buffer *ring, u32 seqno),
 	    TP_ARGS(ring, seqno)
-);
+)
 
 DECLARE_EVENT_CLASS(i915_ring,
 	    TP_PROTO(struct intel_ring_buffer *ring),
@@ -336,17 +336,17 @@ DECLARE_EVENT_CLASS(i915_ring,
 			   ),
 
 	    TP_printk("dev=%u, ring=%u", __entry->dev, __entry->ring)
-);
+)
 
 DEFINE_EVENT(i915_ring, i915_ring_wait_begin,
 	    TP_PROTO(struct intel_ring_buffer *ring),
 	    TP_ARGS(ring)
-);
+)
 
 DEFINE_EVENT(i915_ring, i915_ring_wait_end,
 	    TP_PROTO(struct intel_ring_buffer *ring),
 	    TP_ARGS(ring)
-);
+)
 
 TRACE_EVENT(i915_flip_request,
 	    TP_PROTO(int plane, struct drm_i915_gem_object *obj),
@@ -364,7 +364,7 @@ TRACE_EVENT(i915_flip_request,
 		    ),
 
 	    TP_printk("plane=%d, obj=%p", __entry->plane, __entry->obj)
-);
+)
 
 TRACE_EVENT(i915_flip_complete,
 	    TP_PROTO(int plane, struct drm_i915_gem_object *obj),
@@ -382,7 +382,7 @@ TRACE_EVENT(i915_flip_complete,
 		    ),
 
 	    TP_printk("plane=%d, obj=%p", __entry->plane, __entry->obj)
-);
+)
 
 TRACE_EVENT(i915_reg_rw,
            TP_PROTO(bool write, u32 reg, u64 val, int len),
@@ -408,7 +408,7 @@ TRACE_EVENT(i915_reg_rw,
 		     __entry->reg, __entry->len,
 		     (u32)(__entry->val & 0xffffffff),
 		     (u32)(__entry->val >> 32))
-);
+)
 
 #endif /* _I915_TRACE_H_ */
 
Index: linux-2.6-lttng/drivers/gpu/drm/radeon/radeon_trace.h
===================================================================
--- linux-2.6-lttng.orig/drivers/gpu/drm/radeon/radeon_trace.h
+++ linux-2.6-lttng/drivers/gpu/drm/radeon/radeon_trace.h
@@ -25,7 +25,7 @@ TRACE_EVENT(radeon_bo_create,
 			   __entry->pages = bo->tbo.num_pages;
 			   ),
 	    TP_printk("bo=%p, pages=%u", __entry->bo, __entry->pages)
-);
+)
 
 DECLARE_EVENT_CLASS(radeon_fence_request,
 
@@ -44,35 +44,35 @@ DECLARE_EVENT_CLASS(radeon_fence_request
 			   ),
 
 	    TP_printk("dev=%u, seqno=%u", __entry->dev, __entry->seqno)
-);
+)
 
 DEFINE_EVENT(radeon_fence_request, radeon_fence_emit,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(radeon_fence_request, radeon_fence_retire,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(radeon_fence_request, radeon_fence_wait_begin,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 DEFINE_EVENT(radeon_fence_request, radeon_fence_wait_end,
 
 	    TP_PROTO(struct drm_device *dev, u32 seqno),
 
 	    TP_ARGS(dev, seqno)
-);
+)
 
 #endif
 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
