Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0D3Rve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:51:34 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:55750 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632Ab0D3RvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:51:08 -0400
From: Bill Pemberton <wfp5p@virginia.edu>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] agp:  use NULL instead of 0 when pointer is needed
Date: Fri, 30 Apr 2010 09:34:29 -0400
Message-Id: <1272634478-4127-3-git-send-email-wfp5p@virginia.edu>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
References: <1272634478-4127-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning:

drivers/char/agp/generic.c:1217:33: warning: Using plain integer as
NULL pointer

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
CC: linux-kernel@vger.kernel.org
---
 drivers/char/agp/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index fb86708..4b51982 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -1214,7 +1214,7 @@ struct agp_memory *agp_generic_alloc_user(size_t page_count, int type)
 		return NULL;
 
 	for (i = 0; i < page_count; i++)
-		new->pages[i] = 0;
+		new->pages[i] = NULL;
 	new->page_count = 0;
 	new->type = type;
 	new->num_scratch_pages = pages;
-- 
1.7.0.6

