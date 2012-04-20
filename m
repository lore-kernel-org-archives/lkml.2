Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2DTNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:25:59 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57372 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2DTNZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:25:58 -0400
Subject: [PATCH] lib/kobject.c : Remove redundant check in create_dir
From: yan <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, message.get@gmail.com
Date: Fri, 20 Apr 2012 21:25:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334928359.2018.11.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_dir is a static function used only in kobject_add_internal.
There's no need to do check here, for kobject_add_internal will 
reject kobject with invalid name.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index aeefa8b..38fcc60 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -47,13 +47,11 @@ static int populate_dir(struct kobject *kobj)
 static int create_dir(struct kobject *kobj)
 {
 	int error = 0;
-	if (kobject_name(kobj)) {
-		error = sysfs_create_dir(kobj);
-		if (!error) {
-			error = populate_dir(kobj);
-			if (error)
-				sysfs_remove_dir(kobj);
-		}
+	error = sysfs_create_dir(kobj);
+	if (!error) {
+		error = populate_dir(kobj);
+		if (error)
+			sysfs_remove_dir(kobj);
 	}
 	return error;
 }
-- 
1.7.5.1



