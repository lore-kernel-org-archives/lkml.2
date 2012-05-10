Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab2EJRd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab2EJRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:27 -0400
Message-Id: <20120510173133.084608494@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yang Guang <guang.a.yang@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 01/52] drm/i915: enable dip before writing data on gen4
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit c1230df7e19e0f27655c0eb9d966c7e03be7cc50 upstream.

While testing with the intel_infoframes tool on gen4, I see that when
video DIP is disabled, what we write to the DATA memory is not exactly
what we read back later.

This regression has been introduce in

commit 64a8fc0145a1d0fdc25fc9367c2e6c621955fb3b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Sep 22 11:16:00 2011 +0530

    drm/i915: fix ILK+ infoframe support

That commit was setting VIDEO_DIP_CTL to 0 when initializing, which
caused the problem.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=43947
Tested-by: Yang Guang <guang.a.yang@intel.com>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
[danvet: Pimped commit message by using the usual commit citation
layout.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -136,7 +136,7 @@ static void i9xx_write_infoframe(struct
 
 	val &= ~VIDEO_DIP_SELECT_MASK;
 
-	I915_WRITE(VIDEO_DIP_CTL, val | port | flags);
+	I915_WRITE(VIDEO_DIP_CTL, VIDEO_DIP_ENABLE | val | port | flags);
 
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(VIDEO_DIP_DATA, *data);


