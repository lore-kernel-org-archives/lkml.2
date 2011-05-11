Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1EKRSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:18:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59094 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1EKRSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:18:01 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/radeon/kms: fix bad shift in atom iio table parser" has been added to staging queue
Date: Wed, 11 May 2011 11:29:56 +0200
Message-Id: <1305106196-19269-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/radeon/kms: fix bad shift in atom iio table parser

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 24b424d58a72306ff413315f01f12dab43ac783c Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 14 Apr 2011 11:19:50 -0400
Subject: [PATCH] drm/radeon/kms: fix bad shift in atom iio table parser

commit 8e461123f28e6b17456225e70eb834b3b30d28bb upstream.

Noticed by Patrick Lowry.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index b1f929d..052312f 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -128,7 +128,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_INDEX:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((index >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -138,7 +138,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_DATA:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((data >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -148,7 +148,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_ATTR:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((ctx->
 			      io_attr >> CU8(base + 2)) & (0xFFFFFFFF >> (32 -
--
1.7.0.4

