Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1IGF6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 01:58:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56258 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1IGF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 01:58:47 -0400
MIME-Version: 1.0
Date: Wed, 7 Sep 2011 11:28:46 +0530
Message-ID: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
Subject: CRC calculation in Module.symvers
From: Shakthi Kannan <shakthimaan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings!

I would like to know as to:

1. How the CRC is computed for an exported symbol present in
Module.symvers file, and
2. Given a kernel .c file, how can I obtain the CRC checksums for a symbol.

For linux-3.0.2 (example), I compiled with CONFIG_MODVERSIONS=y, and
running 'make' built vmlinux, and generated the Module.symvers file. I
believe genksyms is used to create the Module.symvers file?

I had referred the "Kernel Symbols and CONFIG_MODVERSIONS"
documentation [1] written by Mark McLoughlin. I tried the following in
the top-level kernel sources:

 $ gcc -E -D__GENKSYMS__ -DCONFIG_MODVERSIONS -DEXPORT_SYMTAB
crypto/api.c -I/tmp/linux-3.0.2/include
-I/tmp/linux-3.0.2/arch/x86/include | ./scripts/genksyms/genksyms

and I get the following error output:

=== Output ===

/tmp/linux-3.0.2/include/linux/jiffies.h:43:42: error: division by zero in #if
In file included from /tmp/linux-3.0.2/include/linux/tracepoint.h:19:0,
                from /tmp/linux-3.0.2/include/linux/module.h:18,
                from crypto/api.c:22:
/tmp/linux-3.0.2/include/linux/rcupdate.h:160:2: error: #error
"Unknown RCU implementation specified to kernel configuration"
In file included from /tmp/linux-3.0.2/include/linux/module.h:21:0,
                from crypto/api.c:22:
/tmp/linux-3.0.2/arch/x86/include/asm/module.h:59:2: error: #error
unknown processor family

=== End ===

The documentation for genksyms is old, and now there is no -k option?

Appreciate any inputs in this regard,

Thanks!

SK

[1] Kernel Symbols and CONFIG_MODVERSIONS.
http://www.skynet.ie/~mark/pub/symbols.txt

-- 
Shakthi Kannan
http://www.shakthimaan.com
