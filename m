Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab2JRN7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:59:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39405 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2JRN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:59:46 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stefani@seibold.net, jkosina@suse.cz
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] remove untouched code in kfifo_in
Date: Thu, 18 Oct 2012 21:59:25 +0800
Message-Id: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12101813-4790-0000-0000-000005222CA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kfifo_in marco, one piece of code is arounded by if(0). This code in
introduced by Stefani Seibold <stefani@seibold.net> to suppress a compiler
warning. This warning is not there with the upgrade of gcc version. 

This patch just remove this code.
---
 include/linux/kfifo.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..e7015bb 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -512,10 +512,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__buf))NULL; \
-	} \
 	(__recsize) ?\
 	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_in(__kfifo, __buf, __n); \
-- 
1.7.5.4

