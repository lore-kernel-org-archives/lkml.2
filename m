Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2AXDCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 22:02:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab2AXCqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:28 2012
Message-Id: <20120124023928.013900288@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: [046/129] include/linux/crash_dump.h needs elf.h
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1577
Lines: 48

From: Fabio Estevam <festevam@gmail.com>

commit 1f536b9e9f85456df93614b3c2f6a1a2b7d7cb9b upstream.

Building an ARM target we get the following warnings:

  CC      arch/arm/kernel/setup.o
  In file included from arch/arm/kernel/setup.c:39:
  arch/arm/include/asm/elf.h:102:1: warning: "vmcore_elf64_check_arch" redefined
  In file included from arch/arm/kernel/setup.c:24:
  include/linux/crash_dump.h:30:1: warning: this is the location of the previous definition

Quoting Russell King:

"linux/crash_dump.h makes no attempt to include asm/elf.h, but it depends
on stuff in asm/elf.h to determine how stuff inside this file is defined
at parse time.

So, if asm/elf.h is included after linux/crash_dump.h or not at all, you
get a different result from the situation where asm/elf.h is included
before."

So add elf.h header to crash_dump.h to avoid this problem.

The original discussion about this can be found at:
http://www.spinics.net/lists/arm-kernel/msg154113.html

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/crash_dump.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -5,6 +5,7 @@
 #include <linux/kexec.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
+#include <linux/elf.h>
 
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)


