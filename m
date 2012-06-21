Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2FUGyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:54:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58508 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2FUGyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:54:08 -0400
Message-ID: <4FE2C505.4000905@gmail.com>
Date: Thu, 21 Jun 2012 14:53:57 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix potential 32bits truncation for result of timespec/timeval_compare()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The tv_nsec field of timespec struct and tv_usec field of timeval
struct are defined as long type, but two comparison API return int
type of result value, this may result in wrong result.

This simple patch fixed it, thanks

Signed-off-by: Li Yu <bingtian.ly@taobao.com>

diff --git a/include/linux/time.h b/include/linux/time.h
index 179f4d6..be381f6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -53,7 +53,7 @@ static inline int timespec_equal(const struct timespec *a,
  * lhs == rhs: return 0
  * lhs > rhs:  return >0
  */
-static inline int timespec_compare(const struct timespec *lhs, const
struct timespec *rhs)
+static inline long timespec_compare(const struct timespec *lhs, const
struct timespec *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
@@ -62,7 +62,7 @@ static inline int timespec_compare(const struct
timespec *lhs, const struct time
 	return lhs->tv_nsec - rhs->tv_nsec;
 }

-static inline int timeval_compare(const struct timeval *lhs, const
struct timeval *rhs)
+static inline long timeval_compare(const struct timeval *lhs, const
struct timeval *rhs)
 {
 	if (lhs->tv_sec < rhs->tv_sec)
 		return -1;
