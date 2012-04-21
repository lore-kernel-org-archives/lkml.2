Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab2DUKR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:17:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60461 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DUKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:17:57 -0400
Subject: [PATCH 4/4][Trivial] lib/kobject.c : check parameter in
 kobject_init_and_add
From: yan <clouds.yan@gmail.com>
To: greg <gregkh@linuxfoundation.org>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Date: Sat, 21 Apr 2012 18:17:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335003475.2188.43.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user turns to the simple interface kobject_init_and_add 
and gives a null kobject, kobject_init can detect it but 
just dumps the stack. Then there is:
  -->kobject_add_varg
   -->kobject_set_name_vargs
In the end, it will reference kobj->name and we have an oops.

Check whether we have a valid kobject in kobject_init_and_add.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index dd67855..bc05922 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -380,6 +380,9 @@ int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
 	va_list args;
 	int retval;
 
+	if (!kobj)
+		return -EINVAL;
+
 	kobject_init(kobj, ktype);
 
 	va_start(args, fmt);
-- 
1.7.5.1



