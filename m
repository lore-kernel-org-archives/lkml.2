Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2DMTjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:39:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36094 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2DMTjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:39:12 -0400
Date: Fri, 13 Apr 2012 14:39:05 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH resend] x86: memtest: WARN if bad RAM found
Message-ID: <20120413193905.GD2387@burratino>
References: <20120402150522.GA4980@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402150522.GA4980@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 5 Dec 2011 04:00:58 +0000

Since this is not a particularly thorough test, if we find any bad
bits of RAM then there is a fair chance that there are other bad bits
we fail to detect.

Warn so the TAINT_WARNING flag shows up in panic traces and other bug
reports from users that enabled memtest and found bad RAM during
bootup, to help people debugging to see that problems are potentially
due to unreliable RAM.  The warning text gives advice that can be used
to make the warning go away using a more thorough test:

	Bad RAM detected. Use memtest86+ to perform a thorough test
	and the memmap= parameter to reserve the bad areas.

In this way, this patch should make the lives of people helping to
analyze bug reports from builds with CONFIG_MEMTEST enabled easier.

[jn: more explanation of impact]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi again,

The patch below last visited this list on 2 April, about a week and a
half ago.  No reply.

The patch has been in Debian since last December.  I like it.  The
patch is targetted at v3.5, so I would like to see it in linux-next so
it can get more exposure.  Comments?

Thanks,
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
1.7.10

