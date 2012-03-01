Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574Ab2CAVum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965375Ab2CAVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.138.137 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213926.942593663@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 29/34] Fix autofs compile without CONFIG_COMPAT
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -311,5 +311,9 @@ asmlinkage long compat_sys_openat(unsign
 
 extern void __user *compat_alloc_user_space(unsigned long len);
 
+#else
+
+#define is_compat_task() (0)
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */


