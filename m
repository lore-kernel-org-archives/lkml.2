Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0G3SbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:31:21 -0400
Received: from kroah.org ([198.145.64.141]:58163 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759814Ab0G3RzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:39 2010
Message-Id: <20100730175139.054224874@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        sroland@vmware.com, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [060/205] drm/radeon/r200: handle more hw tex coord types
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Scheidegger <sroland@vmware.com>

commit 688acaa2897462e4c5e2482496e2868db0760809 upstream.

Code did not handle projected 2d and depth coordinates, meaning potentially
set 3d or cube special handling might stick.
(Not sure what depth coord actually does, but I guess handling it
like a normal coordinate is the right thing to do.)
Might be related to https://bugs.freedesktop.org/show_bug.cgi?id=26428

Signed-off-by: sroland@vmware.com
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r200.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -415,6 +415,8 @@ int r200_packet0_check(struct radeon_cs_
 		/* 2D, 3D, CUBE */
 		switch (tmp) {
 		case 0:
+		case 3:
+		case 4:
 		case 5:
 		case 6:
 		case 7:


