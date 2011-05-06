Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1EFA11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:27:27 -0400
Received: from kroah.org ([198.145.64.141]:37492 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604Ab1EFA1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:08 2011
Message-Id: <20110506002607.987112115@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [07/43] drm/radeon/kms: fix bad shift in atom iio table parser
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 8e461123f28e6b17456225e70eb834b3b30d28bb upstream.

Noticed by Patrick Lowry.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -128,7 +128,7 @@ static uint32_t atom_iio_execute(struct
 		case ATOM_IIO_MOVE_INDEX:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((index >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -138,7 +138,7 @@ static uint32_t atom_iio_execute(struct
 		case ATOM_IIO_MOVE_DATA:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((data >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -148,7 +148,7 @@ static uint32_t atom_iio_execute(struct
 		case ATOM_IIO_MOVE_ATTR:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((ctx->
 			      io_attr >> CU8(base + 2)) & (0xFFFFFFFF >> (32 -


