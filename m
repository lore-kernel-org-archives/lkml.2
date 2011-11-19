Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1KSALw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:11:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1KSAKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:30 2011
Message-Id: <20111119000329.954214328@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [23/26] powerpc: Add hvcall.h include to book3s_hv.c
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit de1d9248eadd27539eba449b4d09428252e80c04 upstream.

If you build with KVM and UP it fails with the following due to a
missing include.

/arch/powerpc/kvm/book3s_hv.c: In function 'do_h_register_vpa':
arch/powerpc/kvm/book3s_hv.c:156:10: error: 'H_PARAMETER' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:156:10: note: each undeclared identifier is reported only once for each function it appears in
arch/powerpc/kvm/book3s_hv.c:192:12: error: 'H_RESOURCE' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:222:9: error: 'H_SUCCESS' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c: In function 'kvmppc_pseries_do_hcall':
arch/powerpc/kvm/book3s_hv.c:228:30: error: 'H_SUCCESS' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:232:7: error: 'H_CEDE' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:234:7: error: 'H_PROD' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:238:10: error: 'H_PARAMETER' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:250:7: error: 'H_CONFER' undeclared (first use in this function)
arch/powerpc/kvm/book3s_hv.c:252:7: error: 'H_REGISTER_VPA' undeclared (first use in this function)
make[2]: *** [arch/powerpc/kvm/book3s_hv.o] Error 1

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kvm/book3s_hv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -43,6 +43,7 @@
 #include <asm/processor.h>
 #include <asm/cputhreads.h>
 #include <asm/page.h>
+#include <asm/hvcall.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>


