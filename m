Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3AGWUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:20:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab3AGWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:20:52 -0500
Message-ID: <50EB4A3B.1020307@suse.com>
Date: Mon, 07 Jan 2013 17:20:43 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/sb105x: remove asm/segment.h dependency
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sb105x doesn't seem to actually need <asm/segment.h> (builds on x86
without it) and ppc/ppc64 doesn't provide it so it fails to build there.

This patch removes the dependency. Unfortunately, it now fails to build
because STD_COM_FLAGS isn't defined on most architectures. I'm not familiar
enough with the tty/serial system to patch that aspect of it.

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/staging/sb105x/sb_pci_mp.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -19,7 +19,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/segment.h>
 #include <asm/serial.h>
 #include <linux/interrupt.h>
 


-- 
Jeff Mahoney
SUSE Labs
