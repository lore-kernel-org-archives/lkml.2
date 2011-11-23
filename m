Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab1KWBEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:04:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988Ab1KWAdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.302363412@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [14/25] drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1407
Lines: 47

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7dcd2499deab8f10011713c40bc2f309c9b65077 upstream

... and do the same for pread.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -482,12 +482,8 @@ i915_gem_pread_ioctl(struct drm_device *
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
@@ -960,12 +956,8 @@ i915_gem_pwrite_ioctl(struct drm_device
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


