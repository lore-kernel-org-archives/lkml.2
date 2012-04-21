Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab2DUJZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:25:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33437 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2DUJZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:25:51 -0400
Subject: [PATCH 1/4][Trivial] lib/kobject.c: Check parameter in
 kobject_get_path
From: yan <clouds.yan@gmail.com>
To: greg <gregkh@linuxfoundation.org>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Date: Sat, 21 Apr 2012 17:25:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335000350.2188.5.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_get_path is exported, it passes its parameter kobj to
get_kobj_path_length and fill_kobj_path which are both static 
and called only once here. So check this parameter.


Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 38fcc60..56c8cb3 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -104,6 +104,9 @@ char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
 	char *path;
 	int len;
 
+	if (!kobj)
+		return NULL;
+
 	len = get_kobj_path_length(kobj);
 	if (len == 0)
 		return NULL;
-- 
1.7.5.1



