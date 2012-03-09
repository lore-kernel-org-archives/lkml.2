Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031397Ab2CITvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36013 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030528Ab2CITu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:58 -0500
Message-Id: <20120309190215.179442456@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 02/68] Fix autofs compile without CONFIG_COMPAT
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3c761ea05a8900a907f32b628611873f6bef24b2 upstream.

The autofs compat handling fix caused a compile failure when
CONFIG_COMPAT isn't defined.

Instead of adding random #ifdef'fery in autofs, let's just make the
compat helpers earlier to use: without CONFIG_COMPAT, is_compat_task()
just hardcodes to zero.

We could probably do something similar for a number of other cases where
we have #ifdef's in code, but this is the low-hanging fruit.

Reported-and-tested-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compat.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -561,5 +561,9 @@ extern ssize_t compat_rw_copy_check_uvec
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
+#else
+
+#define is_compat_task() (0)
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */


