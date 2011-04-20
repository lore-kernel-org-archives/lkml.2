Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1DTKbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:31:52 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:60371 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1DTKbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:31:49 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: [PATCH] asm-generic: solve the conflict of atomic64_t type with linux/types.h and asm-generic/atomic64.h
Date: Wed, 20 Apr 2011 18:31:42 +0800
Message-ID: <00ca01cbff46$24e1ea10$6ea5be30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acv/RhZ5moBib9UgQJ65IpmiKUCLYw==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 include/asm-generic/atomic64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
index b18ce4f..cc6e272 100644
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -12,9 +12,11 @@
 #ifndef _ASM_GENERIC_ATOMIC64_H
 #define _ASM_GENERIC_ATOMIC64_H
 
+#ifndef CONFIG_64BIT
 typedef struct {
 	long long counter;
 } atomic64_t;
+#endif
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
-- 
1.6.2.2


