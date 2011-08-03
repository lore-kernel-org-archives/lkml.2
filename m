Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1HCTwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:52:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46414 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab1HCTwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:52:13 -0400
From: Bojan Prtvar <prtvar.b@gmail.com>
To: airlied@linux.ie
Cc: alexdeucher@gmail.com, airlied@redhat.com, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Bojan Prtvar <prtvar.b@gmail.com>
Subject: [PATCH] Fix potential NULL dereference in drivers/gpu/drm/radeon/atom.c
Date: Wed,  3 Aug 2011 21:51:19 +0200
Message-Id: <1312401079-1775-1-git-send-email-prtvar.b@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() can return NULL, so I added check for it

Signed-off-by: Bojan Prtvar <prtvar.b@gmail.com>
---
 drivers/gpu/drm/radeon/atom.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index ebdb0fd..e88c644 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1245,6 +1245,9 @@ struct atom_context *atom_parse(struct card_info *card, void *bios)
 	char name[512];
 	int i;
 
+	if (!ctx)
+		return NULL;
+
 	ctx->card = card;
 	ctx->bios = bios;
 
-- 
1.7.1

