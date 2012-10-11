Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab2JKXUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 19:20:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50925 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506Ab2JKXUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 19:20:45 -0400
Date: Fri, 12 Oct 2012 01:20:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@hansenpartnership.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/31] sections: Fix section conflicts in arch/frv
Message-ID: <20121011232044.GZ16230@one.firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-4-git-send-email-andi@firstfloor.org> <CAMuHMdWJCLnWpuNFvQQSJU0w4fQLg6rYbDOQF2But1__NrgiAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWJCLnWpuNFvQQSJU0w4fQLg6rYbDOQF2But1__NrgiAg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately __pminitconst isn't defined at this point:
> arch/frv/kernel/setup.c:187:47: error: expected '=', ',', ';', 'asm'
> or '__attribute__' before '*' token
> arch/frv/kernel/setup.c:386:2: error: 'clock_cmodes' undeclared (first
> use in this function)
> arch/frv/kernel/setup.c:571:6: error: 'clock_cmodes' undeclared (first
> use in this function)
> make[2]: *** [arch/frv/kernel/setup.o] Error 1
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/7344691/
> 
> It seems the __pminit* variants are frv-specific, and don't cover all possible
> combinations?

Thanks for reporting.

Does this fix it? -Andi

---

frv: Fix const sections changhe
    
Add __pminitconst to fix the build again.
    
Reported by: Geert Uytterhoeven
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 1f1e5ef..b8993c8 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -112,9 +112,11 @@ char __initdata redboot_command_line[COMMAND_LINE_SIZE];
 #ifdef CONFIG_PM
 #define __pminit
 #define __pminitdata
+#define __pminitconst
 #else
 #define __pminit __init
 #define __pminitdata __initdata
+#define __pminitconst __initconst
 #endif
 
 struct clock_cmode {
