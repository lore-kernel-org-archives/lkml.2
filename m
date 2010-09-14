Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0INUYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:24:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab0INUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/15] libfs: use generic_file_llseek for simple_attr
Date: Tue, 14 Sep 2010 22:22:40 +0200
Message-Id: <1284495763-7506-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NpfskxSez7GJZx9A68Ndtpmy4IZrWNk1JSN0jx1aTYM
 ny59f5topoqUPVfr2xjzpKVpRWhS90BABhtM5F9GChIJZRizH3
 CSYJvQdzbOKkumVI3w0wBy5IkjpjPc5iOYrQZPC+2kPBMYp4hQ
 mq2vYjtgK8CcFNjVNHUJh9y0QAgiGHF0zQU8tFT9S9KTX3VLIF
 fU/A7jbJRkI7IigaV+U7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple attribute files need to be seekable to
allow resetting the file for another read.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..c8effc8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2450,6 +2450,7 @@ static const struct file_operations __fops = {				\
 	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
+	.llseek	 = generic_file_llseek,					\
 };
 
 static inline void __attribute__((format(printf, 1, 2)))
-- 
1.7.1

