Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0KVOkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:40:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:49102 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab0KVOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:40:08 -0500
Message-ID: <4CEA80AD.2030804@windriver.com>
Date: Mon, 22 Nov 2010 08:39:41 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64,kgdb: add default case into a switch
References: <1290409375-28187-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1290409375-28187-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 14:39:42.0872 (UTC) FILETIME=[19B9D980:01CB8A53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 01:02 AM, Namhyung Kim wrote:
> This fixes following sparse warning on x86_64:
> 
>  arch/x86/kernel/kgdb.c:123:9: warning: switch with no cases
> 

Thanks for the report on this.  

The preferred fix for the warning is below, and I'll queue it for the 2.6.38 merge window.

Thanks,
Jason.

--

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb,x86_64: fix compile warning found with sparse
Date: Mon Nov 22 08:38:04 CST 2010

Fix sparse warning:

arch/x86/kernel/kgdb.c:123:9: warning: switch with no cases

Reported-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/x86/kernel/kgdb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -120,8 +120,8 @@ char *dbg_get_reg(int regno, void *mem, 
 		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
 		       dbg_reg_def[regno].size);
 
-	switch (regno) {
 #ifdef CONFIG_X86_32
+	switch (regno) {
 	case GDB_SS:
 		if (!user_mode_vm(regs))
 			*(unsigned long *)mem = __KERNEL_DS;
@@ -134,8 +134,8 @@ char *dbg_get_reg(int regno, void *mem, 
 	case GDB_FS:
 		*(unsigned long *)mem = 0xFFFF;
 		break;
-#endif
 	}
+#endif
 	return dbg_reg_def[regno].name;
 }
 
