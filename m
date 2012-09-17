Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2IQBNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:13:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33686 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab2IQAu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:29 -0400
Message-Id: <20120917003636.861951865@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marc Gariepy <mgariepy@ubuntu.com>,
        Adam Jackson <ajax@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 077/135] fixing dmi match for hp t5745 and hp st5747 thin client
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Gariepy <mgariepy@ubuntu.com>

commit 62004978df3898649e152751eb6ac264a323ec36 upstream.

Match the correct information which is DMI_PRODUCT_NAME instead of DMI_BOARD_NAME
See dmidecode information on launchpad for both thin client:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/911920
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/911916

Signed-off-by: Marc Gariepy <mgariepy@ubuntu.com>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 30e2c82..9c71183 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -750,7 +750,7 @@ static const struct dmi_system_id intel_no_lvds[] = {
 		.ident = "Hewlett-Packard t5745",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "hp t5745"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "hp t5745"),
 		},
 	},
 	{
@@ -758,7 +758,7 @@ static const struct dmi_system_id intel_no_lvds[] = {
 		.ident = "Hewlett-Packard st5747",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_NAME, "hp st5747"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "hp st5747"),
 		},
 	},
 	{


