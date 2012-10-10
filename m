Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2JKANh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:13:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34558 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932305Ab2JKAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:13:29 -0400
X-Sasl-enc: pZkMbpnV276Lmo63XYrHZUIUI2SsYY3KClbbZmhBNRVx 1349914408
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 085/133] drm/i915: prevent possible pin leak on error path
Date: Thu, 11 Oct 2012 07:51:51 +0900
Message-Id: <20121010224909.794559909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit ab3951eb74e7c33a2f5b7b64d72e82f1eea61571 upstream.

We should not hit this under any sane conditions, but still, this does not
looks right.

Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wlison <chris@chris-wilson.co.uk>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6167,7 +6167,7 @@ static int intel_gen7_queue_flip(struct
 	default:
 		WARN_ONCE(1, "unknown plane in flip command\n");
 		ret = -ENODEV;
-		goto err;
+		goto err_unpin;
 	}
 
 	ret = intel_ring_begin(ring, 4);


