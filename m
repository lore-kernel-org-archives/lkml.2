Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1ABH42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:56:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:35409 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1ABHXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 105/260] i915: return -EFAULT if copy_to_user fails
Date: Sun,  2 Jan 2011 02:16:41 -0500
Message-Id: <1293952756-15010-106-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:05.0102 (UTC) FILETIME=[C1CFDCE0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit c877cdce93a44eea96f6cf7fc04be7d0372db2be upstream.

copy_to_user() returns the number of bytes remaining to be copied and
I'm pretty sure we want to return a negative error code here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 37a9ea3..e07722a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3818,6 +3818,7 @@ i915_gem_do_execbuffer(struct drm_device *dev, void *data,
 		if (ret != 0) {
 			DRM_ERROR("copy %d cliprects failed: %d\n",
 				  args->num_cliprects, ret);
+			ret = -EFAULT;
 			goto pre_mutex_err;
 		}
 	}
-- 
1.7.3.3

