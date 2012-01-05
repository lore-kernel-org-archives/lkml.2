Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2AEWgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:36:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab2AEWgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:36:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jan  5 14:29:59 2012
Message-Id: <20120105222959.057469511@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Thu, 05 Jan 2012 14:30:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [75/80] drm/radeon/kms/atom: fix possible segfault in pm setup
In-Reply-To: <20120105223610.GA9914@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1216
Lines: 36

From: =?UTF-8?q?Alexander=20M=C3=BCller?= <serveralex@gmail.com>

commit 4376eee92e5a8332b470040e672ea99cd44c826a upstream.

If we end up with no power states, don't look up
current vddc.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=44130

agd5f: fix patch formatting

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2568,7 +2568,11 @@ void radeon_atombios_get_power_modes(str
 
 	rdev->pm.current_power_state_index = rdev->pm.default_power_state_index;
 	rdev->pm.current_clock_mode_index = 0;
-	rdev->pm.current_vddc = rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
+	if (rdev->pm.default_power_state_index >= 0)
+		rdev->pm.current_vddc =
+			rdev->pm.power_state[rdev->pm.default_power_state_index].clock_info[0].voltage.voltage;
+	else
+		rdev->pm.current_vddc = 0;
 }
 
 void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable)


