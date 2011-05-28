Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab1E1E33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 00:29:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1E1E32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 00:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YWXuY9E1V/h/ZWWth6KJgqgG9xSc9WLHIRMq7uSyU3Du79l0n1Ag6pwOlXSkSAyswQ
         JXeoMVLHibPYD52EMv0xx2qP/ngFL2AHLV9rz9JQKFOUiqWGh1HCtW1TyEN4STmrqGR9
         LL7BRL2IL+iqvAp8q+PPpPxSOygfG2fKGgAdo=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: fix regression after clock gating init split
Date: Sat, 28 May 2011 14:26:48 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
References: <201105272344.20084.jasonbstubbs@gmail.com> <yunaae8j5dg.fsf@aiko.keithp.com>
In-Reply-To: <yunaae8j5dg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281426.49040.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

During the refactoring in revision 6067aaeadb5b3df26f27ac827256b1ef01e674f5,
the intel_enable_clock_gating was split up into several functions that are
then called indirectly. However, which function to call was not specified for
the IS_PINEVIEW() case. This patch specifies the correct gating function.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f553ddf..bb1b59b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7675,6 +7675,7 @@ static void intel_init_display(struct drm_device *dev)
 			dev_priv->display.update_wm = NULL;
 		} else
 			dev_priv->display.update_wm = pineview_update_wm;
+		dev_priv->display.init_clock_gating = gen3_init_clock_gating;
 	} else if (IS_G4X(dev)) {
 		dev_priv->display.update_wm = g4x_update_wm;
 		dev_priv->display.init_clock_gating = g4x_init_clock_gating;
