Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab1LGQUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:20:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564Ab1LGQU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:20:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.679127908@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:13 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alex Davis <alex14641@yahoo.com>,
        Takashi Iwai <tiwai@suse.de>, Keith Packard <keithp@keithp.com>
Subject: [011/104] drm/i915: Fix inconsistent backlight level during disabled
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 04b38670cf46c096705f24e92a8747d1ab89e53c upstream.

When the brightness property is inquired while the backlight is disabled,
the driver returns a wrong value (zero) because it probes the value after
the backlight was turned off.  This caused a black screen even after the
backlight is enabled again.  It should return the internal backlight_level
instead, so that it won't be influenced by the backlight-enable state.

BugLink: https://bugs.freedesktop.org/show_bug.cgi?id=41926
BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/872652

Tested-by: Kamal Mostafa <kamal@canonical.com>
Cc: Alex Davis <alex14641@yahoo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_panel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -326,7 +326,8 @@ static int intel_panel_update_status(str
 static int intel_panel_get_brightness(struct backlight_device *bd)
 {
 	struct drm_device *dev = bl_get_data(bd);
-	return intel_panel_get_backlight(dev);
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	return dev_priv->backlight_level;
 }
 
 static const struct backlight_ops intel_panel_bl_ops = {


