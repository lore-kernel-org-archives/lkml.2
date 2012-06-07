Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab2FGESG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:18:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809Ab2FGESC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:02 -0400
Message-Id: <20120607040340.903447096@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:07 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Robert Lowery <rglowery@exemail.com.au>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 31/82] drm/i915: Adding TV Out Missing modes.
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@gmail.com>

commit 9589919fb3d269d4202a112b197468c7db1f97a3 upstream.

These 2 modes were removed by mistake during a clean up.
So, now it is time to add them back. For further info about
supported mode and standard timing table please check:
VOL_3_display_registers_updated.pdf at intellinuxgraphics.org.

Note that this regression has been introduce in

commit 55a6713b3f30a5024056027e9dbf03ac8f13bfc9
Author: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Date:   Thu Dec 15 14:47:33 2011 -0200

    drm/i915: Removing TV Out modes.

and this commit partially reverts it by re-adding the wrongly removed
modes.

Reported-by: Robert Lowery <rglowery@exemail.com.au>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
[danvet: Pimped commit message to cite the commit that introduced this
regression.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_tv.c |   48 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -674,6 +674,54 @@ static const struct tv_mode tv_modes[] =
 		.filter_table = filter_table,
 	},
 	{
+		.name       = "480p",
+		.clock		= 107520,
+		.refresh	= 59940,
+		.oversample     = TV_OVERSAMPLE_4X,
+		.component_only = 1,
+
+		.hsync_end      = 64,               .hblank_end         = 122,
+		.hblank_start   = 842,              .htotal             = 857,
+
+		.progressive    = true,		    .trilevel_sync = false,
+
+		.vsync_start_f1 = 12,               .vsync_start_f2     = 12,
+		.vsync_len      = 12,
+
+		.veq_ena        = false,
+
+		.vi_end_f1      = 44,               .vi_end_f2          = 44,
+		.nbr_end        = 479,
+
+		.burst_ena      = false,
+
+		.filter_table = filter_table,
+	},
+	{
+		.name       = "576p",
+		.clock		= 107520,
+		.refresh	= 50000,
+		.oversample     = TV_OVERSAMPLE_4X,
+		.component_only = 1,
+
+		.hsync_end      = 64,               .hblank_end         = 139,
+		.hblank_start   = 859,              .htotal             = 863,
+
+		.progressive    = true,		    .trilevel_sync = false,
+
+		.vsync_start_f1 = 10,               .vsync_start_f2     = 10,
+		.vsync_len      = 10,
+
+		.veq_ena        = false,
+
+		.vi_end_f1      = 48,               .vi_end_f2          = 48,
+		.nbr_end        = 575,
+
+		.burst_ena      = false,
+
+		.filter_table = filter_table,
+	},
+	{
 		.name       = "720p@60Hz",
 		.clock		= 148800,
 		.refresh	= 60000,


