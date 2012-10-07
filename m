Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2JGXfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:35:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38460 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab2JGXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:43 -0400
Message-Id: <20121007225843.966679575@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Avi Kivity <avi@redhat.com>, Tomas Racek <tracek@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 067/108] x86/alternatives: Fix p6 nops on non-modular kernels
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

commit cb09cad44f07044d9810f18f6f9a6a6f3771f979 upstream.

Probably a leftover from the early days of self-patching, p6nops
are marked __initconst_or_module, which causes them to be
discarded in a non-modular kernel.  If something later triggers
patching, it will overwrite kernel code with garbage.

Reported-by: Tomas Racek <tracek@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org
Cc: Anthony Liguori <anthony@codemonkey.ws>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/5034AE84.90708@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..ced4534 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -165,7 +165,7 @@ static const unsigned char * const k7_nops[ASM_NOP_MAX+2] =
 #endif
 
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =
+static const unsigned char p6nops[] =
 {
 	P6_NOP1,
 	P6_NOP2,


