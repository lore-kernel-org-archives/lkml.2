Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1DZVPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:1640 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab1DZVO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951450"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [88/106] drm/radeon/kms: fix bad shift in atom iio table parser
Message-Id: <20110426211410.4E3E13E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 8e461123f28e6b17456225e70eb834b3b30d28bb upstream.

Noticed by Patrick Lowry.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/atom.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/atom.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/atom.c
@@ -131,7 +131,7 @@ static uint32_t atom_iio_execute(struct 
 		case ATOM_IIO_MOVE_INDEX:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((index >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -141,7 +141,7 @@ static uint32_t atom_iio_execute(struct 
 		case ATOM_IIO_MOVE_DATA:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((data >> CU8(base + 2)) &
 			     (0xFFFFFFFF >> (32 - CU8(base + 1)))) << CU8(base +
@@ -151,7 +151,7 @@ static uint32_t atom_iio_execute(struct 
 		case ATOM_IIO_MOVE_ATTR:
 			temp &=
 			    ~((0xFFFFFFFF >> (32 - CU8(base + 1))) <<
-			      CU8(base + 2));
+			      CU8(base + 3));
 			temp |=
 			    ((ctx->
 			      io_attr >> CU8(base + 2)) & (0xFFFFFFFF >> (32 -
