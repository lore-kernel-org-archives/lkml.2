Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946148Ab2I1VP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:15:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60159 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759427Ab2I1Ujw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:52 -0400
X-Sasl-enc: QtK1VJwutg80QXvI6cpkFQIhg48euMvdGDoCc0W6GjJN 1348864791
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 218/218] Revert: drm/i915: correctly order the ring init sequence
Date: Fri, 28 Sep 2012 13:17:15 -0700
Message-Id: <20120928201526.624277842@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 57ecc93ce680b1ace1f9e79d588dabe32353202c which
really is commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 upstream as it
has been reported to cause problems in the 3.4.y kernel series.

Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Yang Guang <guang.a.yang@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -258,6 +258,8 @@ static int init_ring_common(struct intel
 	I915_WRITE_HEAD(ring, 0);
 	ring->write_tail(ring, 0);
 
+	/* Initialize the ring. */
+	I915_WRITE_START(ring, obj->gtt_offset);
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
 
 	/* G45 ring initialization fails to reset head to zero */
@@ -283,11 +285,6 @@ static int init_ring_common(struct intel
 		}
 	}
 
-	/* Initialize the ring. This must happen _after_ we've cleared the ring
-	 * registers with the above sequence (the readback of the HEAD registers
-	 * also enforces ordering), otherwise the hw might lose the new ring
-	 * register values. */
-	I915_WRITE_START(ring, obj->gtt_offset);
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_VALID);


