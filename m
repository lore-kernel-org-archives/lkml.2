Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2DXCug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:50:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48854 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2DXCuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:50:35 -0400
Date: Mon, 23 Apr 2012 21:50:25 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>
Subject: [PATCH v4] x86: memtest: WARN if bad RAM found
Message-ID: <20120424025025.GA22927@burratino>
References: <20120402150522.GA4980@burratino>
 <20120413193905.GD2387@burratino>
 <20120423182630.GA13067@burratino>
 <CAE9FiQVSdnqrno4VBZbcQmcYagpXPOo_Cvw=c9w_1GZycKv1Xg@mail.gmail.com>
 <20120423202839.GA14147@burratino>
 <CAE9FiQVaThbo0oQZThc9JdEtu53CWfBvFAH6Sc9bpkwFSVAFiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVaThbo0oQZThc9JdEtu53CWfBvFAH6Sc9bpkwFSVAFiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

The novice who enables CONFIG_MEMTEST may not realize that this is not
a particularly thorough test.  If we find any bad bits of RAM then
there is a fair chance that there are other bad bits we fail to
detect; add a WARNING for this situation so people helping debug
ensuing problems can understand what happened.

The warning text gives advice to allow the sysadmin to address the
warning by fixing the underlying problem or running a more thorough
test and using the memmap= parameter to reserve bad areas.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Yinghai Lu wrote:

> The reason for adding early_memtest is for debug purpose.
> Sometimes BIOS mess up setting, on some booting memory is ok, but
> other booting the memory is not initialized properly.
>
> in that case: preboot memtest tools is not going to help.
[... and another hint about how memtest86 may be more suitable
 than memtest86+ in some situations]

Makes perfect sense.  How about this?

This punts to Documentation/memory.txt for advice, in the hope of
nudging people to improve that document where it is lacking (hint,
hint).

Thanks,
Jonathan

 arch/x86/mm/memtest.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb95734..d26067d5ddec 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -30,6 +30,7 @@ static u64 patterns[] __initdata = {
 
 static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
 {
+	WARN_ONCE(1, "Bad RAM detected. See Documentation/memory.txt for hints.");
 	printk(KERN_INFO "  %016llx bad mem addr %010llx - %010llx reserved\n",
 	       (unsigned long long) pattern,
 	       (unsigned long long) start_bad,
-- 
1.7.10

