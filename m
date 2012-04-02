Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2DBPFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:05:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38297 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2DBPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:05:45 -0400
Date: Mon, 2 Apr 2012 10:05:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: memtest: WARN if bad RAM found
Message-ID: <20120402150522.GA4980@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 5 Dec 2011 04:00:58 +0000

Since this is not a particularly thorough test, if we find any bad
bits of RAM then there is a fair chance that there are other bad bits
we fail to detect.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi,

The patch below comes from this discussion

  http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=50;bug=613321

and has been in use in Debian kernels since last December.  The
rationale does not seem particularly distro-specific, and all in all
it looks to me like a good change.

Nothing urgent here.  I imagine this patch as targetted to v3.5.

Thoughts?
Jonathan

 arch/x86/mm/memtest.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb95734..38caeb44a218 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -30,6 +30,8 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 {
+	WARN_ONCE(1, "Bad RAM detected. Use memtest86+ to perform a thorough test\n"
+		  "and the memmap= parameter to reserve the bad areas.");
 	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
-- 
1.7.10.rc3

