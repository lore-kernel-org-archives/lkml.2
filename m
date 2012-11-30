Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2K3TVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:21:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:58565 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992775Ab2K3S4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ryan Underwood <nemesis@icequake.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 10/56] x86, efi: Fix processor-specific memcpy() build error
Date: Fri, 30 Nov 2012 10:55:02 -0800
Message-Id: <20121130185119.405964366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 0f905a43ce955b638139bd84486194770a6a2c08 upstream.

Building for Athlon/Duron/K7 results in the following build error,

arch/x86/boot/compressed/eboot.o: In function `__constant_memcpy3d':
eboot.c:(.text+0x385): undefined reference to `_mmx_memcpy'
arch/x86/boot/compressed/eboot.o: In function `efi_main':
eboot.c:(.text+0x1a22): undefined reference to `_mmx_memcpy'

because the boot stub code doesn't link with the kernel proper, and
therefore doesn't have access to the 3DNow version of memcpy. So,
follow the example of misc.c and #undef memcpy so that we use the
version provided by misc.c.

See https://bugzilla.kernel.org/show_bug.cgi?id=50391

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Ryan Underwood <nemesis@icequake.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,8 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 
+#undef memcpy			/* Use memcpy from misc.c */
+
 #include "eboot.h"
 
 static efi_system_table_t *sys_table;


