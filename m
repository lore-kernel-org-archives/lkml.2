Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490Ab2I1TDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:03:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47421 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476Ab2I1TDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        dri-devel@lists.freedesktop.org, Adam Jackson <ajax@redhat.com>,
        Ian Pilcher <arequipeno@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 192/262] drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S
Date: Fri, 28 Sep 2012 11:52:01 -0700
Message-Id: <20120928183020.741351559@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    3 +++
 1 file changed, 3 insertions(+)

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


