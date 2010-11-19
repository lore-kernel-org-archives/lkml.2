Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0KSWFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:05:05 -0500
Received: from kroah.org ([198.145.64.141]:53139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217Ab0KSWEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:39 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:27 2010
Message-Id: <20101119220127.531723933@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mac Lin <mkl0301@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [65/66] ARM: cns3xxx: Fixup the missing second parameter to addruart macro to allow them to build.
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mac Lin <mkl0301@gmail.com>

It can't be merged into Linus' tree because this file has already been
changed in incompatible ways.

Fixup the missing second parameter to addruart macro to allow them to build,
according to to commit 0e17226f7cd289504724466f4298abc9bdfca3fe.

Enabling DEBUG in head.S would cause:
rch/arm/boot/compressed/head.S: Assembler messages:
arch/arm/boot/compressed/head.S:1037: Error: too many positional arguments
arch/arm/boot/compressed/head.S:1055: Error: too many positional arguments

Signed-off-by: Mac Lin <mkl0301@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-cns3xxx/include/mach/debug-macro.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-cns3xxx/include/mach/debug-macro.S
+++ b/arch/arm/mach-cns3xxx/include/mach/debug-macro.S
@@ -10,7 +10,7 @@
  * published by the Free Software Foundation.
  */
 
-		.macro	addruart,rx
+		.macro	addruart,rx,rtmp
 		mrc	p15, 0, \rx, c1, c0
 		tst	\rx, #1			@ MMU enabled?
 		moveq	\rx,      #0x10000000


