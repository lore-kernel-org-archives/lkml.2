Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946541Ab2CPXws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:52:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946210Ab2CPXjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:39:22 -0400
Message-Id: <20120316233450.408627737@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>
Subject: [ 35/38] compat: Re-add missing asm/compat.h include to fix compile breakage on s390
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

For 3.0 stable kernel the backport of 048cd4e51d24ebf7f3552226d03c769d6ad91658
"compat: fix compile breakage on s390" breaks compilation...

Re-add a single #include <asm/compat.h> in order to fix this.

This patch is _not_ necessary for upstream, only for stable kernels
which include the "build fix" mentioned above.

One fix for arch/s390/kernel/setup.c was already sent and applied. But
we need a similar patch for drivers/s390/char/fs3270.c.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/char/fs3270.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/compat.h>
 
+#include <asm/compat.h>
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
 #include <asm/ebcdic.h>


