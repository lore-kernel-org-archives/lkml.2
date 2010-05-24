Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0EXX1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:27:13 -0400
Received: from kroah.org ([198.145.64.141]:59491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636Ab0EXXXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:52 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:16 2010
Message-Id: <20100524231816.071942512@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Hooker <sarvatt@ubuntu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [32/39] drm/i915: Disable FBC on 915GM and 945GM.
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Robert Hooker <sarvatt@ubuntu.com>

commit 8d06a1e1e9c69244f08beb7d17146483f9dcd120 upstream.

It is causing hangs after a suspend/resume cycle with the default
powersave=1 module option on these chipsets since 2.6.32-rc.

BugLink: http://bugs.launchpad.net/bugs/492392
Signed-off-by: Robert Hooker <sarvatt@ubuntu.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -79,14 +79,14 @@ const static struct intel_device_info in
 	.is_i915g = 1, .is_i9xx = 1, .cursor_needs_physical = 1,
 };
 const static struct intel_device_info intel_i915gm_info = {
-	.is_i9xx = 1,  .is_mobile = 1, .has_fbc = 1,
+	.is_i9xx = 1,  .is_mobile = 1,
 	.cursor_needs_physical = 1,
 };
 const static struct intel_device_info intel_i945g_info = {
 	.is_i9xx = 1, .has_hotplug = 1, .cursor_needs_physical = 1,
 };
 const static struct intel_device_info intel_i945gm_info = {
-	.is_i945gm = 1, .is_i9xx = 1, .is_mobile = 1, .has_fbc = 1,
+	.is_i945gm = 1, .is_i9xx = 1, .is_mobile = 1,
 	.has_hotplug = 1, .cursor_needs_physical = 1,
 };
 
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4683,7 +4683,7 @@ static void intel_init_display(struct dr
 			dev_priv->display.fbc_enabled = g4x_fbc_enabled;
 			dev_priv->display.enable_fbc = g4x_enable_fbc;
 			dev_priv->display.disable_fbc = g4x_disable_fbc;
-		} else if (IS_I965GM(dev) || IS_I945GM(dev) || IS_I915GM(dev)) {
+		} else if (IS_I965GM(dev)) {
 			dev_priv->display.fbc_enabled = i8xx_fbc_enabled;
 			dev_priv->display.enable_fbc = i8xx_enable_fbc;
 			dev_priv->display.disable_fbc = i8xx_disable_fbc;


