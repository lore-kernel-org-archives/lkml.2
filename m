Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032288Ab2I1UZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:25:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032274Ab2I1UY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [ 065/218] oprofile, s390: Fix uninitialized memory access when writing to oprofilefs
Date: Fri, 28 Sep 2012 13:14:42 -0700
Message-Id: <20120928201508.989748694@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 81ff3478d9ba7f0b48b0abef740e542fd83adf79 upstream.

If oprofilefs_ulong_from_user() is called with count equals zero, *val
remains unchanged. Depending on the implementation it might be
uninitialized. Fixing users of oprofilefs_ulong_ from_user().

We missed these s390 changes with:

 913050b oprofile: Fix uninitialized memory access when writing to writing to oprofilefs

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/oprofile/init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -171,7 +171,7 @@ static ssize_t hw_interval_write(struct
 	if (*offset)
 		return -EINVAL;
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val < oprofile_min_interval)
 		oprofile_hw_interval = oprofile_min_interval;
@@ -214,7 +214,7 @@ static ssize_t hwsampler_zero_write(stru
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 	if (val != 0)
 		return -EINVAL;
@@ -245,7 +245,7 @@ static ssize_t hwsampler_kernel_write(st
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -280,7 +280,7 @@ static ssize_t hwsampler_user_write(stru
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)
@@ -319,7 +319,7 @@ static ssize_t timer_enabled_write(struc
 		return -EINVAL;
 
 	retval = oprofilefs_ulong_from_user(&val, buf, count);
-	if (retval)
+	if (retval <= 0)
 		return retval;
 
 	if (val != 0 && val != 1)


