Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab2CITsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030812Ab2CITsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:38 -0500
Message-Id: <20120309190206.855135588@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wu Fengguang <fengguang.wu@intel.com>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 56/95] drm/i915: fix ELD writing for SandyBridge
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit b3f33cbf7ace8fc149993ee35e0d0fd57f41d6d8 upstream.

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5876,14 +5876,14 @@ static void ironlake_write_eld(struct dr
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
-	if (IS_IVYBRIDGE(connector->dev)) {
-		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
-		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
-		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
-	} else {
+	if (HAS_PCH_IBX(connector->dev)) {
 		hdmiw_hdmiedid = GEN5_HDMIW_HDMIEDID_A;
 		aud_cntl_st = GEN5_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = GEN5_AUD_CNTL_ST2;
+	} else {
+		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
+		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
+		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
 	}
 
 	i = to_intel_crtc(crtc)->pipe;


