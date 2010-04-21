Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab0DUVMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:12:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19629 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab0DUVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:12:30 -0400
Date: Wed, 21 Apr 2010 14:11:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] microblaze: fix divide by zero exception message
Message-Id: <20100421141134.56eff2f5.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BCF6A12.0063:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix divide exception message to say "divide by zero".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Michal Simek <monstr@monstr.eu>
Cc:	microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/kernel/exceptions.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.34-rc4-git6.orig/arch/microblaze/kernel/exceptions.c
+++ linux-2.6.34-rc4-git6/arch/microblaze/kernel/exceptions.c
@@ -121,7 +121,7 @@ asmlinkage void full_exception(struct pt
 		}
 		printk(KERN_WARNING "Divide by zero exception " \
 							"in kernel mode.\n");
-		die("Divide by exception", regs, SIGBUS);
+		die("Divide by zero exception", regs, SIGBUS);
 		break;
 	case MICROBLAZE_FPU_EXCEPTION:
 		pr_debug(KERN_WARNING "FPU exception\n");
