Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0LHA7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:13 -0500
Received: from kroah.org ([198.145.64.141]:48326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab0LHA7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:06 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:22 2010
Message-Id: <20101208005722.493462300@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [011/289] drm/radeon/kms: fix 2D tile height alignment in the r600 CS checker
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 354da653233898ed1e51f20cebac9705456bf9b1 upstream.

macro tile heights are aligned to num channels, not num banks.

Noticed by Dave Airlie.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600_cs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -228,7 +228,7 @@ static inline int r600_cs_track_validate
 				__func__, __LINE__, pitch);
 			return -EINVAL;
 		}
-		if (!IS_ALIGNED((height / 8), track->nbanks)) {
+		if (!IS_ALIGNED((height / 8), track->npipes)) {
 			dev_warn(p->dev, "%s:%d cb height (%d) invalid\n",
 				 __func__, __LINE__, height);
 			return -EINVAL;
@@ -367,7 +367,7 @@ static int r600_cs_track_check(struct ra
 						 __func__, __LINE__, pitch);
 					return -EINVAL;
 				}
-				if ((height / 8) & (track->nbanks - 1)) {
+				if (!IS_ALIGNED((height / 8), track->npipes)) {
 					dev_warn(p->dev, "%s:%d db height (%d) invalid\n",
 						 __func__, __LINE__, height);
 					return -EINVAL;


