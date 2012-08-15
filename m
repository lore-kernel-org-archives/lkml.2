Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2HOUHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:07:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63086 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab2HOTwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 133/165] drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow
Date: Wed, 15 Aug 2012 15:47:57 -0400
Message-ID: <1345060109-9187-134-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7dcd2499deab8f10011713c40bc2f309c9b65077 upstream.

... and do the same for pread.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fd51c36..82d798b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -481,12 +481,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = to_intel_bo(obj);
 
-	/* Bounds check source.
-	 *
-	 * XXX: This could use review for overflow issues...
-	 */
-	if (args->offset > obj->size || args->size > obj->size ||
-	    args->offset + args->size > obj->size) {
+	/* Bounds check source.  */
+	if (args->offset > obj->size || args->size > obj->size - args->offset) {
 		ret = -EINVAL;
 		goto err;
 	}
@@ -959,12 +955,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = to_intel_bo(obj);
 
-	/* Bounds check destination.
-	 *
-	 * XXX: This could use review for overflow issues...
-	 */
-	if (args->offset > obj->size || args->size > obj->size ||
-	    args->offset + args->size > obj->size) {
+	/* Bounds check destination. */
+	if (args->offset > obj->size || args->size > obj->size - args->offset) {
 		ret = -EINVAL;
 		goto err;
 	}
-- 
1.7.12.rc2

