Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1EZLz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:55:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57590 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1EZLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:55:28 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [2.6.32+drm33-longterm] Linux 2.6.32.41+drm33.18
Date: Thu, 26 May 2011 13:55:23 +0200
Message-Id: <1306410923-5409-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the 2.6.32.41+drm33.18 longterm tree.

This tree is based on 2.6.32 and generally has all of the stable updates
applied. Except those to the DRM subsystem, which was based on 2.6.33 and
took updates from that upstream stable as long as that existed. It will
continue to add patches to the DRM subsystem as long as they are valid
according to the stable update rules (Documentation/stable_kernel_rules.txt).
DRM patches for this tree should be sent to kernel-team@lists.ubuntu.com.

This release updates the DRM subsystem only.

The updated 2.6.32.y-drm33.z tree can be found at:
  git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
and can be browsed through git web via:
  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=summary

-Stefan

------

* drm/radeon/kms: fix bad shift in atom iio table parser
* Linux 2.6.32.41+drm33.18

 Makefile                      |    2 +-
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index f942779..183bd18 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .41+drm33.17
+EXTRAVERSION = .41+drm33.18
 NAME = Man-Eating Seals of Antiquity

 # *DOCUMENTATION*
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
