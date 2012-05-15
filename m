Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676Ab2EOCSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:49346 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964910Ab2EOCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 053/179] drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007
Date: Mon, 14 May 2012 22:12:29 -0400
Message-ID: <1337048075-6132-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6a574b5b9b186e28abd3e571dfd1700c5220b510 upstream.

I found this while figuring out why gnome-shell would not run on my
Asus EeeBox PC EB1007. As a standalone "pc" this device cleary does not have
an internal panel, yet it claims it does. Add a quirk to fix this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Keith Packard <keithp@keithp.com>
cc: stable@kernel.org
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 4072b0d..1183b42 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -876,6 +876,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "U800"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Asus EeeBox PC EB1007",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EB1007"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
-- 
1.7.9.6

