Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1LARUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:20:30 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:36038 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755222Ab1LARU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:20:27 -0500
Message-ID: <4ED7C51F.3090007@xenotime.net>
Date: Thu, 01 Dec 2011 10:19:11 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH -next] exit: fix writeback build errors
References: <20111201155342.45847a6edcf25cde48c4a6de@canb.auug.org.au>
In-Reply-To: <20111201155342.45847a6edcf25cde48c4a6de@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors:
kernel/exit.c:1039:3: error: 'dirty_throttle_leaks' undeclared (first use in this function)
kernel/exit.c:1039:3: warning: type defaults to 'int' in type name
kernel/exit.c:1039:3: warning: initialization makes pointer from integer without a cast
kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/exit.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20111201.orig/kernel/exit.c
+++ linux-next-20111201/kernel/exit.c
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/writeback.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
