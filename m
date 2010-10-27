Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab0J0BBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:01:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38073 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760755Ab0J0BBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:01:02 -0400
Date: Wed, 27 Oct 2010 12:00:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the xen tree with Linus' tree
Message-Id: <20101027120054.249d1df5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the xen tree got a conflict in
arch/x86/xen/mmu.c between commit
fef5ba797991f9335bcfc295942b684f9bf613a1 ("xen: Cope with unmapped pages
when initializing kernel pagetable") from Linus' tree and commit
41f2e4771a4f1ba26c35438daf32917b9ef7858d ("xen: add support for PAT")
from the xen tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/xen/mmu.c
index f72d18c,6ba8f8a..0000000
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@@ -56,7 -55,7 +56,8 @@@
  #include <asm/e820.h>
  #include <asm/linkage.h>
  #include <asm/page.h>
 +#include <asm/init.h>
+ #include <asm/pat.h>
  
  #include <asm/xen/hypercall.h>
  #include <asm/xen/hypervisor.h>
