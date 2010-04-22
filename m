Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0DVTt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:49:58 -0400
Received: from kroah.org ([198.145.64.141]:40967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0DVT2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:50 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:16 2010
Message-Id: <20100422190916.405279565@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephane Graber <stgraber@ubuntu.com>,
       Stefan Bader <stefan.bader@canonical.com>,
       Eric Anholt <eric@anholt.net>
Subject: [101/197] drm/i915: Add no_lvds entry for the Clientron U800
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit 9875557ee8247c3f7390d378c027b45c7535a224 upstream.

BugLink: http://bugs.launchpad.net/ubuntu/bugs/544671

This system claims to have a LVDS but has not.

Signed-off-by: Stephane Graber <stgraber@ubuntu.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -885,6 +885,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Clientron U800",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Clientron"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


