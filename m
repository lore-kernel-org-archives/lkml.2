Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0LaTOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:14:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50440 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0LaTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:13:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AIa5oUHLTpGL9tvhJLu7TxUvGkcsDL/aIOOij2o8N5Tsi+aqZDLjAsecylGUy/bI0n
         1YmjwkBWUaPV6OviyZcBdYXneOAxgZ8Lm18wknAB25CYxSTnYXX7kf03M/32edJV7BTw
         2K8r8254i9g/I3qBaTp+6pv9vnUpTWWR14oSk=
Date: Fri, 31 Dec 2010 20:13:47 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V8 04/13] posix_clocks: add clock_adjtime for arm
Message-ID: <5a4e56322f44083a532d9c474eccb7b26354e990.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1293820862.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the clock_adjtime system call to the arm architecture.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 arch/arm/include/asm/unistd.h |    1 +
 arch/arm/kernel/calls.S       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index c891eb7..f58d881 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -396,6 +396,7 @@
 #define __NR_fanotify_init		(__NR_SYSCALL_BASE+367)
 #define __NR_fanotify_mark		(__NR_SYSCALL_BASE+368)
 #define __NR_prlimit64			(__NR_SYSCALL_BASE+369)
+#define __NR_clock_adjtime		(__NR_SYSCALL_BASE+370)
 
 /*
  * The following SWIs are ARM private.
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 5c26ecc..430de4c 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -379,6 +379,7 @@
 		CALL(sys_fanotify_init)
 		CALL(sys_fanotify_mark)
 		CALL(sys_prlimit64)
+/* 370 */	CALL(sys_clock_adjtime)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
-- 
1.7.0.4

