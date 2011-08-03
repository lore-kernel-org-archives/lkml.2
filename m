Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab1HCXgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:36:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1HCXaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.269386284@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lasse Collin <lasse.collin@tukaani.org>
Subject: [062/102] XZ: Fix missing <linux/kernel.h> include
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lasse Collin <lasse.collin@tukaani.org>

commit 81d67439855a7f928d90965d832aa4f2fb677342 upstream.

<linux/kernel.h> is needed for min_t. The old version
happened to work on x86 because <asm/unaligned.h>
indirectly includes <linux/kernel.h>, but it didn't
work on ARM.

<linux/kernel.h> includes <asm/byteorder.h> so it's
not necessary to include it explicitly anymore.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/xz/xz_private.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -12,7 +12,7 @@
 
 #ifdef __KERNEL__
 #	include <linux/xz.h>
-#	include <asm/byteorder.h>
+#	include <linux/kernel.h>
 #	include <asm/unaligned.h>
 	/* XZ_PREBOOT may be defined only via decompress_unxz.c. */
 #	ifndef XZ_PREBOOT


