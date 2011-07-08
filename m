Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1GHFSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:18:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab1GHFBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.188175888@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [025/107] drm/radeon/kms: Fix chremap setup on RV770 CE
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit daf54f1f363a61c618662ef66d4bf09d2b090941 upstream.

CE variant requires a different chremap setup.

Fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=35472

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/rv770.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -572,6 +572,12 @@ static void rv770_program_channel_remap(
 	else
 		tcp_chan_steer = 0x00fac688;
 
+	/* RV770 CE has special chremap setup */
+	if (rdev->pdev->device == 0x944e) {
+		tcp_chan_steer = 0x00b08b08;
+		mc_shared_chremap = 0x00b08b08;
+	}
+
 	WREG32(TCP_CHAN_STEER, tcp_chan_steer);
 	WREG32(MC_SHARED_CHREMAP, mc_shared_chremap);
 }


