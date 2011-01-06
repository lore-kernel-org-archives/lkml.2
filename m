Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AFA3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:18 -0500
Received: from kroah.org ([198.145.64.141]:35500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1AFA3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:14 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.489348802@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [030/152] x86, xsave: Use alloc_bootmem_align() instead of alloc_bootmem()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit 10340ae130fb70352eae1ae8a00b7906d91bf166 upstream.

Alignment of alloc_bootmem() depends on the value of
L1_CACHE_SHIFT. What we need here, however, is 64 byte alignment.  Use
alloc_bootmem_align() and explicitly specify the alignment instead.

This fixes a kernel boot crash reported by Jody when the cpu in .config
is set to MPENTIUMII but the kernel is booted on a xsave-capable CPU.

Reported-by: Jody Bruchon <jody@nctritech.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20101116212442.059967454@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/xsave.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -394,7 +394,8 @@ static void __init setup_xstate_init(voi
 	 * Setup init_xstate_buf to represent the init state of
 	 * all the features managed by the xsave
 	 */
-	init_xstate_buf = alloc_bootmem(xstate_size);
+	init_xstate_buf = alloc_bootmem_align(xstate_size,
+					      __alignof__(struct xsave_struct));
 	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
 
 	clts();


