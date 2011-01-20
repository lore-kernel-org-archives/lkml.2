Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1ATScQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:32:16 -0500
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:34728 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753582Ab1ATScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:32:14 -0500
Subject: [PATCH 2/3] quota: return -ENOMEM when memory allocation fails
From: Davidlohr Bueso <dave@gnu.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 15:32:05 -0300
Message-ID: <1295548325.2089.12.camel@offworld>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/quota/quota_v2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index 65444d2..f1ab360 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -112,7 +112,7 @@ static int v2_read_file_info(struct super_block *sb, int type)
 	if (!info->dqi_priv) {
 		printk(KERN_WARNING
 		       "Not enough memory for quota information structure.\n");
-		return -1;
+		return -ENOMEM;
 	}
 	qinfo = info->dqi_priv;
 	if (version == 0) {
-- 
1.7.1




