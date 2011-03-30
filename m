Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab1C3QGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:06:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35013 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1C3QGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:06:13 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Dann Frazier <dannf@debian.org>, Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 2/2] drm/radeon: fix regression with AA resolve checking" has been added to staging queue
Date: Wed, 30 Mar 2011 18:06:05 +0200
Message-Id: <1301501165-11052-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Dave Airlie <airlied@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 2/2] drm/radeon: fix regression with AA resolve checking

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 2d84b55365a1a9e31af7acac9698362272663220 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Tue, 29 Mar 2011 15:23:31 -0600
Subject: [PATCH 2/2] drm/radeon: fix regression with AA resolve checking

Some userspaces can emit a whole packet without disabling AA resolve
by the looks of it, so we have to deal with them.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Tested-by: Jorg Otte <jrg.otte@googlemail.com>

(cherry-picked from commit 45e4039c3aea597ede44a264cea322908cdedfe9 upstream)
Signed-off-by: Dann Frazier <dannf@debian.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 2cfb39f..947570c 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3031,7 +3031,7 @@ void r100_cs_track_clear(struct radeon_device *rdev, struct r100_cs_track *track
 		track->num_texture = 16;
 		track->maxy = 4096;
 		track->separate_cube = 0;
-		track->aaresolve = true;
+		track->aaresolve = false;
 		track->aa.robj = NULL;
 	}

--
1.7.0.4

