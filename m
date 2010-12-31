Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0LaTOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:14:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50440 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0LaTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LoWqaanF96Y0p+xpi/JyV7f2J3+gL2Dn/ev17mZ7fjZ309kC0g43+Ia6O240qTFIMI
         ArLSEC2qz++Wfd0CYvdAoNnQ5pps8UCLjmSjKzNmqcnH9XBPZd2l6jZ+qtJ8Gja4XVcE
         KyLCKG6sQ9knRMrq06i0VM0YyetvS9m7k0omc=
Date: Fri, 31 Dec 2010 20:14:07 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V8 05/13] posix_clocks: add clock_adjtime for blackfin
Message-ID: <0a011917c6a869ca9dd22d56f95bc2c3aeb5621a.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1293820862.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the clock_adjtime system call to the blackfin architecture.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 arch/blackfin/include/asm/unistd.h |    3 ++-
 arch/blackfin/mach-common/entry.S  |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/unistd.h b/arch/blackfin/include/asm/unistd.h
index 928ae97..e640c51 100644
--- a/arch/blackfin/include/asm/unistd.h
+++ b/arch/blackfin/include/asm/unistd.h
@@ -393,8 +393,9 @@
 #define __NR_fanotify_mark	372
 #define __NR_prlimit64		373
 #define __NR_cacheflush		374
+#define __NR_clock_adjtime	375
 
-#define __NR_syscall		375
+#define __NR_syscall		376
 #define NR_syscalls		__NR_syscall
 
 /* Old optional stuff no one actually uses */
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 2ca915e..cb6cc1e 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -1738,6 +1738,7 @@ ENTRY(_sys_call_table)
 	.long _sys_fanotify_mark
 	.long _sys_prlimit64
 	.long _sys_cacheflush
+	.long _sys_clock_adjtime	/* 375 */
 
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
-- 
1.7.0.4

