Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2DUJbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:31:34 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56750 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2DUJbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:31:33 -0400
Subject: [PATCH 2/4][Trivial] lib/kobject.c : Check parameter in
 kobject_set_name
From: yan <clouds.yan@gmail.com>
To: greg <gregkh@linuxfoundation.org>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Date: Sat, 21 Apr 2012 17:31:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335000692.2188.10.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_set_name is exported and is just a wrapper for kobject_set_name_vargs
which does not check its parameter kobj. 
So check this parameter in kobject_set_name.


Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 56c8cb3..dd67855 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -248,6 +248,9 @@ int kobject_set_name(struct kobject *kobj, const char *fmt, ...)
 	va_list vargs;
 	int retval;
 
+	if (!kobj)
+		return -EINVAL;
+
 	va_start(vargs, fmt);
 	retval = kobject_set_name_vargs(kobj, fmt, vargs);
 	va_end(vargs);
-- 
1.7.5.1



