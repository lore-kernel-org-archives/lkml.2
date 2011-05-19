Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab1ESSWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:22:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57825 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933898Ab1ESSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:06 -0400
X-Sasl-enc: Cg7XgjbtIiEeJcKop5TEorPy6fIpb6s7r+srC/zWJtaD 1305828485
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.918072951@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: [17/71] drm/i915/lvds: Only act on lid notify when the device is on
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 2fb4e61d9471867677c97bf11dba8f1e9dfa7f7c upstream.

If we're using vga switcheroo, the device may be turned off
and poking it can return random state. This provokes an OOPS fixed
separately by 8ff887c847 (drm/i915/dp: Be paranoid in case we disable a
DP before it is attached). Trying to use and respond to events on a
device that has been turned off by the user is in principle a silly thing
to do.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -540,6 +540,9 @@ static int intel_lid_notify(struct notif
 	struct drm_device *dev = dev_priv->dev;
 	struct drm_connector *connector = dev_priv->int_lvds_connector;
 
+	if (dev->switch_power_state != DRM_SWITCH_POWER_ON)
+		return NOTIFY_OK;
+
 	/*
 	 * check and update the status of LVDS connector after receiving
 	 * the LID nofication event.


