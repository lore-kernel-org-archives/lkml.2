Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0JFAJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:09:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60621 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0JFAJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:09:39 -0400
Date: Wed, 6 Oct 2010 11:09:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure in Linus' tree
Message-Id: <20101006110935.e332fdf9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Today's linux-next initial build (powerpc ppc64_defconfig) failed like
this:

cc1: warnings being treated as errors
arch/powerpc/kernel/module.c: In function 'module_finalize':
arch/powerpc/kernel/module.c:66: error: unused variable 'err'

Caused by commit 5336377d6225959624146629ce3fc88ee8ecda3d ("modules: Fix
module_bug_list list corruption race").

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 6 Oct 2010 11:06:44 +1100
Subject: [PATCH] powerpc: remove unused variable

Since powerpc uses -Werror on arch powerpc, the build was broken like
this:

cc1: warnings being treated as errors
arch/powerpc/kernel/module.c: In function 'module_finalize':
arch/powerpc/kernel/module.c:66: error: unused variable 'err'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/module.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/module.c b/arch/powerpc/kernel/module.c
index 4ef93ae..49cee9d 100644
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -63,7 +63,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 		const Elf_Shdr *sechdrs, struct module *me)
 {
 	const Elf_Shdr *sect;
-	int err;
 
 	/* Apply feature fixups */
 	sect = find_section(hdr, sechdrs, "__ftr_fixup");
-- 
1.7.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
