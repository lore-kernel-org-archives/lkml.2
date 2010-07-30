Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab0G3R4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:56:20 -0400
Received: from kroah.org ([198.145.64.141]:58500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759964Ab0G3Rzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175141.236360691@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [084/205] x86: Fix vsyscall on gcc 4.5 with -Os
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 124482935fb7fb9303c8a8ab930149c6a93d9910 upstream.

This fixes the -Os breaks with gcc 4.5 bug.  rdtsc_barrier needs to be
force inlined, otherwise user space will jump into kernel space and
kill init.

This also addresses http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44129
I believe.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20100618210859.GA10913@basil.fritz.box>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -451,7 +451,7 @@ void stop_this_cpu(void *dummy);
  *
  * (Could use an alternative three way for this if there was one.)
  */
-static inline void rdtsc_barrier(void)
+static __always_inline void rdtsc_barrier(void)
 {
 	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);


