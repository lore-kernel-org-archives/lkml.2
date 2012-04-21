Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab2DUKSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:18:37 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38819 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab2DUKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:18:29 -0400
Subject: [PATCH][Trivial] lib/kobject.c: Remove redundant check in
 populate_dir
From: yan <clouds.yan@gmail.com>
To: greg <gregkh@linuxfoundation.org>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Date: Sat, 21 Apr 2012 18:18:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335003508.2188.44.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_dir will call sysfs_create_dir and then populate_dir.
If ktype of kobject is null, sysfs_craete_dir will lead to
oops first. There is no need to check ktype in populate_dir.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index bc05922..85d5e9b 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -34,7 +34,7 @@ static int populate_dir(struct kobject *kobj)
 	int error = 0;
 	int i;
 
-	if (t && t->default_attrs) {
+	if (t->default_attrs) {
 		for (i = 0; (attr = t->default_attrs[i]) != NULL; i++) {
 			error = sysfs_create_file(kobj, attr);
 			if (error)
-- 
1.7.5.1



