Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab2CMAW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:47896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab2CMAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 090/196] drm/radeon/kms: fix bad shift in atom iio table parser
Date: Mon, 12 Mar 2012 20:20:03 -0400
Message-Id: <1331598109-31424-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8e461123f28e6b17456225e70eb834b3b30d28bb upstream.

Noticed by Patrick Lowry.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 1d56983..b913bf1 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -131,7 +131,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_INDEX:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((index >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -141,7 +141,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_DATA:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((data >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -151,7 +151,7 @@ static uint32_t atom_iio_execute(struct atom_context *ctx, int base,
 		case ATOM_IIO_MOVE_ATTR:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((ctx->
 			      io_attr >> CU8(base + 2)) & (0xFFFFFFFF >> (32 -
-- 
1.7.9.3

