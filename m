Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab2I1S5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2I1S5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [ 078/262] oprofile, s390: Fix uninitialized memory access when writing to oprofilefs
Date: Fri, 28 Sep 2012 11:50:07 -0700
Message-Id: <20120928183007.267676996@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


