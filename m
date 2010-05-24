Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0EXXaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:30:13 -0400
Received: from kroah.org ([198.145.64.141]:59379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab0EXXXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:36 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:14 2010
Message-Id: <20100524231814.457330567@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [14/39] drm/i915: fix non-Ironlake 965 class crashes
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 1918ad77f7f908ed67cf37c505c6ad4ac52f1ecf upstream.

My PIPE_CONTROL fix (just sent via Eric's tree) was buggy; I was
testing a whole set of patches together and missed a conversion to the
new HAS_PIPE_CONTROL macro, which will cause breakage on non-Ironlake
965 class chips.  Fortunately, the fix is trivial and has been tested.

Be sure to use the HAS_PIPE_CONTROL macro in i915_get_gem_seqno, or
we'll end up reading the wrong graphics memory, likely causing hangs,
crashes, or worse.

Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1785,7 +1785,7 @@ i915_get_gem_seqno(struct drm_device *de
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	if (IS_I965G(dev))
+	if (HAS_PIPE_CONTROL(dev))
 		return ((volatile u32 *)(dev_priv->seqno_page))[0];
 	else
 		return READ_HWSP(dev_priv, I915_GEM_HWS_INDEX);


