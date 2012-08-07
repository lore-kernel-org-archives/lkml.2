Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2HGWjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:39:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56573 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030586Ab2HGWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:39:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: =?UTF-8?q?=5B=20057/109=5D=20drm/radeon=3A=20fix=20fence=20related=20segfault=20in=20CS?=
Date: Tue,  7 Aug 2012 15:35:16 -0700
Message-Id: <20120807222048.101526832@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <deathsimple@vodafone.de>

commit 93bf888c5c730605e3470f5d2381f296eda88d79 upstream.

Don't return success if scheduling the IB fails, otherwise
we end up with an oops in ttm_eu_fence_buffer_objects.

Signed-off-by: Christian König <deathsimple@vodafone.de>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -377,7 +377,7 @@ static int radeon_cs_ib_chunk(struct rad
 	if (r) {
 		DRM_ERROR("Failed to schedule IB !\n");
 	}
-	return 0;
+	return r;
 }
 
 static int radeon_bo_vm_update_pte(struct radeon_cs_parser *parser,


