Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab0HKNFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:05:25 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:39422 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752163Ab0HKNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:05:24 -0400
Subject: [PATCH] i915: Remove redundant NULL check upon kfree()
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        eric@anholt.net
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 09:05:18 -0400
Message-ID: <1281531918.2067.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i915: Remove redundant NULL check upon kfree().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/gpu/drm/i915/intel_dvo.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 227feca..b3955bc 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -283,8 +283,7 @@ static void intel_dvo_enc_destroy(struct drm_encoder *encoder)
 	if (dvo) {
 		if (dvo->dev_ops->destroy)
 			dvo->dev_ops->destroy(dvo);
-		if (dvo->panel_fixed_mode)
-			kfree(dvo->panel_fixed_mode);
+		kfree(dvo->panel_fixed_mode);
 	}
 	if (intel_encoder->i2c_bus)
 		intel_i2c_destroy(intel_encoder->i2c_bus);
-- 
1.7.0.4



