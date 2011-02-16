Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab1BPAwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:52:04 -0500
Received: from kroah.org ([198.145.64.141]:46251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab1BPAv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:15 2011
Message-Id: <20110216002115.201549981@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@gmail.com>
Subject: [patch 162/176] radeon/kms: fix dp displayport mode validation
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 6bba2e116808ca12e30c8d88dfedabf8b8d67390 upstream.

Check if there is a big enough dp clock & enough dp lane to
drive the video mode provided.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-By: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -187,9 +187,9 @@ static int dp_link_clock_for_mode_clock(
 int dp_mode_valid(u8 dpcd[DP_DPCD_SIZE], int mode_clock)
 {
 	int lanes = dp_lanes_for_mode_clock(dpcd, mode_clock);
-	int bw = dp_lanes_for_mode_clock(dpcd, mode_clock);
+	int dp_clock = dp_link_clock_for_mode_clock(dpcd, mode_clock);
 
-	if ((lanes == 0) || (bw == 0))
+	if ((lanes == 0) || (dp_clock == 0))
 		return MODE_CLOCK_HIGH;
 
 	return MODE_OK;


