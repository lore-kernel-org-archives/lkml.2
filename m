Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2IQAvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874Ab2IQAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:42 -0400
Message-Id: <20120917003630.011572222@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        <dri-devel@lists.freedesktop.org>, Adam Jackson <ajax@redhat.com>,
        Ian Pilcher <arequipeno@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 027/135] drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <paulepanter@users.sourceforge.net>

commit 6f33814bd4d9cfe76033a31b1c0c76c960cd8e4b upstream.

Connecting an ASUS VW222S [1] over VGA a garbled screen is shown with
vertical stripes in the top half.

In commit bc42aabc [2]

        commit bc42aabc6a01b92b0f961d65671564e0e1cd7592
        Author: Adam Jackson <ajax@redhat.com>
        Date:   Wed May 23 16:26:54 2012 -0400

            drm/edid/quirks: ViewSonic VA2026w

Adam Jackson added the quirk `EDID_QUIRK_FORCE_REDUCED_BLANKING` which
is also needed for this ASUS monitor.

All log files and output from `xrandr` is included in the referenced
Bugzilla report #17629.

Please note that this monitor only has a VGA (D-Sub) connector [1].

[1] http://www.asus.com/Display/LCD_Monitors/VW222S/
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=bc42aabc6a01b92b0f961d65671564e0e1cd7592

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=17629
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: <dri-devel@lists.freedesktop.org>
Cc: Adam Jackson <ajax@redhat.com>
Cc: Ian Pilcher <arequipeno@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_edid.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index a8743c3..b7ee230 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -87,6 +87,9 @@ static struct edid_quirk {
 	int product_id;
 	u32 quirks;
 } edid_quirk_list[] = {
+	/* ASUS VW222S */
+	{ "ACI", 0x22a2, EDID_QUIRK_FORCE_REDUCED_BLANKING },
+
 	/* Acer AL1706 */
 	{ "ACR", 44358, EDID_QUIRK_PREFER_LARGE_60 },
 	/* Acer F51 */


