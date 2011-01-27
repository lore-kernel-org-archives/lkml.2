Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1A0K5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:57:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1A0K5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S9yazFCSavg3t4z9PE07IGGsmb1J3Q+kYcJT5i3Cjt5HbmUEtthLoMyrG5Sobe7bYb
         /S374f830bfXNh4F64vGRojqEa5IOfYdx9dTSegyI2GVXd0lZmiEyAW9aLkB6wxnoTkD
         WyO0QV1bLSYvs3F472qAabGqefX2unQTZovpQ=
Date: Thu, 27 Jan 2011 11:57:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH V10 06/15] posix_clocks: add clock_adjtime for blackfin
Message-ID: <c7f97e54605e23880e09a444b3e9403b14d87169.1296124770.git.richard.cochran@omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1296124770.git.richard.cochran@omicron.at>
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
index bc08c98..ab8b4d7 100644
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

