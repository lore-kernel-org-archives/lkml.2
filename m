Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1HNQ07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:26:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1HNQHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.608696531@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>
Subject: [28/90] drm/i915: Fixup for Hold mode_config->mutex during hotplug
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit 40ee3381dd1010432acc13e907329029096c5bfc upstream.

drm_helper_hpd_irq_event queues another work proc to go and deliver
the user-space event, and that function also wants to hold the config
mutex, so we shouldn't hold the mutex across the
drm_helper_hpd_irq_event call.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -313,10 +313,10 @@ static void i915_hotplug_work_func(struc
 		if (encoder->hot_plug)
 			encoder->hot_plug(encoder);
 
+	mutex_unlock(&mode_config->mutex);
+
 	/* Just fire off a uevent and let userspace tell us what to do */
 	drm_helper_hpd_irq_event(dev);
-
-	mutex_unlock(&mode_config->mutex);
 }
 
 static void i915_handle_rps_change(struct drm_device *dev)


