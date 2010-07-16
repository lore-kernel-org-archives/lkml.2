Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007Ab0GPQNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:13:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43734 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965998Ab0GPQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KPunWQwg2ovmeKPuHYvtYJgG3TGG9ctxQL9YWxcH+dCEEpHcDI/A0gR1IMV9tleJN3
         16k8sfkjNv+iEZkLVI+FodbKxTJ+QlCj4SaJUD1rNRBWoWx2b1aVD3cU1Ez3O+NgYAjw
         FO0kPtrGOyaK3HqDAxDWcauvnI/k0ExttCF2s=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/15] drm: radeon: check kzalloc() result
Date: Fri, 16 Jul 2010 20:13:33 +0400
Message-Id: <1279296814-24903-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/gpu/drm/radeon/r300.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 7e81db5..767c109 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1176,6 +1176,8 @@ int r300_cs_parse(struct radeon_cs_parser *p)
 	int r;
 
 	track = kzalloc(sizeof(*track), GFP_KERNEL);
+	if (track == NULL)
+		return -ENOMEM;
 	r100_cs_track_clear(p->rdev, track);
 	p->track = track;
 	do {
-- 
1.7.0.4

