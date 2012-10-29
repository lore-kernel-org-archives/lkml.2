Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab2J2VnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:43:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:48980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168Ab2J2VmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:42:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 54/54] drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13
Date: Mon, 29 Oct 2012 14:40:55 -0700
Message-Id: <20121029213808.801554851@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

commit 9756fe38d10b2bf90c81dc4d2f17d5632e135364 upstream.

This box claims to have an LVDS interface but doesn't
actually have one.

Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -777,6 +777,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_BOARD_NAME, "MS-7469"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "ZOTAC ZBOXSD-ID12/ID13",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ZOTAC"),
+			DMI_MATCH(DMI_BOARD_NAME, "ZBOXSD-ID12/ID13"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


