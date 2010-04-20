Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DTDbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:31:13 -0400
Received: from verein.lst.de ([213.95.11.210]:41861 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab0DTDbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:31:12 -0400
Date: Tue, 20 Apr 2010 05:31:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: torvalds@linux-foundation.org
Cc: Andy Isaacson <adi@hexapodia.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: correctly wire up the newuname system call
Message-ID: <20100420033102.GA13406@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit e28cbf22933d0c0ccaf3c4c27a1a263b41f73859 64-bit x86 had
a private implementation of sys_uname which was just called sys_uname,
which other architectures used for the old uname.  Due to some merge
issues with the uname refactoring patches we ended up calling the
old uname version for both the old and new system call slots, which
lead to the domainname filed never be set which caused failures with
libnss_nis.

Reported-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/x86/ia32/ia32entry.S
===================================================================
--- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2010-04-19 20:21:11.919003961 -0700
+++ linux-2.6/arch/x86/ia32/ia32entry.S	2010-04-19 20:21:19.902005565 -0700
@@ -626,7 +626,7 @@ ia32_sys_call_table:
 	.quad stub32_sigreturn
 	.quad stub32_clone		/* 120 */
 	.quad sys_setdomainname
-	.quad sys_uname
+	.quad sys_newuname
 	.quad sys_modify_ldt
 	.quad compat_sys_adjtimex
 	.quad sys32_mprotect		/* 125 */
