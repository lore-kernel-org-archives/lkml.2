Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab2EJXhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:37:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab2EJXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:37:38 -0400
Date: Thu, 10 May 2012 16:37:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Charlebois <mcharleb@qualcomm.com>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, hank <pyu@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] time: don't inline EXPORT_SYMBOL functions
Message-ID: <20120510233734.GA17139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

How is the compiler even handling exported functions that are marked
inline?  Anyway, these shouldn't be inline because of that, so remove
that marking.

Based on a larger patch by Mark Charlebois to get LLVM to build the
kernel.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Charlebois <mcharleb@qualcomm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: hank <pyu@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index ba744cf..8d8bebd9 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -232,7 +232,7 @@ EXPORT_SYMBOL(current_fs_time);
  * Avoid unnecessary multiplications/divisions in the
  * two most common HZ cases:
  */
-inline unsigned int jiffies_to_msecs(const unsigned long j)
+unsigned int jiffies_to_msecs(const unsigned long j)
 {
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
 	return (MSEC_PER_SEC / HZ) * j;
@@ -248,7 +248,7 @@ inline unsigned int jiffies_to_msecs(const unsigned long j)
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
 
-inline unsigned int jiffies_to_usecs(const unsigned long j)
+unsigned int jiffies_to_usecs(const unsigned long j)
 {
 #if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
 	return (USEC_PER_SEC / HZ) * j;
