Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1JMVXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:23:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39435 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1JMVXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:23:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Bojan Smojver" <bojan@rexursive.com>
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Thu, 13 Oct 2011 23:26:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <201110062045.48689.rjw@sisk.pl> <2409186928.1003010428@rexursive.com>
In-Reply-To: <2409186928.1003010428@rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110132326.02041.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 13, 2011, Bojan Smojver wrote:
> ------- Original message -------
> > From: Rafael J. Wysocki
> 
> >> I get a kernel panic on a test box using a x86_64 kernel with this patch
> >> applied.
> >
> > The panic happens during late resume, when trying to switch to the 
> > hibernated
> > kernel.
> 
> In an effort to test this whole thing a bit more, I took today's kernel 
> from Linus' repo and applied v11 of my patch. I compiled this on a single 
> cpu machine this time, with 768 MB of memory (in today's terms, this laptop 
> would not pass as a smartphone :-), running F-16 beta.. The system has 
> radeon graphics (my other system, where I initially developed the patch, 
> has intel). Also, this was a 32-bit box, as opposed to my other system, 
> which is 64-bit.
> 
> I was getting kernel trouble on repeated hibernate/thaw cycles on both 
> systems when KMS was enabled. With nomodeset passed into the kernel, both 
> systems would go through 50+ cycles (this was my test loop) with no 
> trouble. Whether my patch was applied or not didn't matter - I was getting 
> trouble with Fedora supplied kernels as well, after a few cycles.
> 
> So, I don't know for sure, but it seems to me something is amiss in KMS 
> when it comes to hibernation.

If your system is 64-bit, then the patch below may help.

Thanks,
Rafael

---
 arch/x86/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/mm/init.c
===================================================================
--- linux.orig/arch/x86/mm/init.c
+++ linux/arch/x86/mm/init.c
@@ -63,9 +63,9 @@ static void __init find_early_table_spac
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
 
 	good_end = max_pfn_mapped << PAGE_SHIFT;
-#endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
