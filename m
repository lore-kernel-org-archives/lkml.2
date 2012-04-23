Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2DWS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:26:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44210 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2DWS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:26:40 -0400
Date: Mon, 23 Apr 2012 13:26:30 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>
Subject: [PATCH resend v3] x86: memtest: WARN if bad RAM found
Message-ID: <20120423182630.GA13067@burratino>
References: <20120402150522.GA4980@burratino>
 <20120413193905.GD2387@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413193905.GD2387@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 5 Dec 2011 04:00:58 +0000

The novice who enables CONFIG_MEMTEST may not realize that it is not a
particularly thorough test.  If we find any bad bits of RAM then there
is a fair chance that there are other bad bits we fail to detect; add
a WARNING for this situation so people helping debug ensuing problems
can understand what happened.

The warning text gives advice to allow the sysadmin to run a more
thorough test and suppress the warning.

	Bad RAM detected. Use memtest86+ to perform a thorough test
	and the memmap= parameter to reserve the bad areas.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Jonathan Nieder wrote:

> The patch below last visited this list on 2 April, about a week and a
> half ago.  No reply.

Are Ben and I the only ones who care either way about this change?

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

