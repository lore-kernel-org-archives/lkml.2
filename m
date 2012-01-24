Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2AXCmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2AXCmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.531004452@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [018/129] drm/radeon/kms: disable writeback on pre-R300 asics
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1126
Lines: 34

From: Alex Deucher <alexander.deucher@amd.com>

commit 28eebb703e28bc455ba704adb1026f76649b768c upstream.

We often end up missing fences on older asics with
writeback enabled which leads to delays in the userspace
accel code, so just disable it by default on those asics.

Reported-by: Helge Deller <deller@gmx.de>
Reported-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_device.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -224,8 +224,11 @@ int radeon_wb_init(struct radeon_device
 	if (radeon_no_wb == 1)
 		rdev->wb.enabled = false;
 	else {
-		/* often unreliable on AGP */
 		if (rdev->flags & RADEON_IS_AGP) {
+			/* often unreliable on AGP */
+			rdev->wb.enabled = false;
+		} else if (rdev->family < CHIP_R300) {
+			/* often unreliable on pre-r300 */
 			rdev->wb.enabled = false;
 		} else {
 			rdev->wb.enabled = true;


