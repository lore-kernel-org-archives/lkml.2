Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1DZM17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:27:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57478 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1DZM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:49 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 19/21] drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow" has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:47 +0200
Message-Id: <1303820807-3969-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 19/21] drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 6c0dedad8e172854079f117e8c47c81506bef991 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 26 Sep 2010 20:21:44 +0100
Subject: [PATCH 19/21] drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow

commit 7dcd2499deab8f10011713c40bc2f309c9b65077 upstream.

... and do the same for pread.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org

[Backported to Debian's 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 366abe3..a34fd44 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -482,12 +482,8 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = obj->driver_private;

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
@@ -960,12 +956,8 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		return -EBADF;
 	obj_priv = obj->driver_private;

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
1.7.0.4

