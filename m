Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2LRJmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:42:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:50107 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2LRJmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:42:15 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: stefani@seibold.net
Subject: [PATCH 3/6] Make vsyscall_gtod_data compatible with 32 bit VDSO
Date: Tue, 18 Dec 2012 10:40:53 +0100
Message-Id: <1355823656-13902-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355823656-13902-1-git-send-email-stefani@seibold.net>
References: <1355823656-13902-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

To make the vsyscall_gtod_data available for both VDSO (X86_64 and
IA32_EMULATION) the alignment must be set to 4. Otherwise the code
create with "gcc -m32" will fail, since the structure alignment in 32
bit mode ist 4 byte.

There is currently no drawback for X86_64, since the structure members
are in a good order.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vgtod.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index eb87b53..86afff8 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
 		cycle_t	mask;
 		u32	mult;
 		u32	shift;
-	} clock;
+	} __attribute__((aligned(4),packed)) clock;
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
@@ -24,7 +24,8 @@ struct vsyscall_gtod_data {
 	struct timezone sys_tz;
 	struct timespec wall_time_coarse;
 	struct timespec monotonic_time_coarse;
-};
+} __attribute__((aligned(4),packed));
+
 extern struct vsyscall_gtod_data vsyscall_gtod_data;
 
 extern void map_vgtod(void);
-- 
1.8.0

