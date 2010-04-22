Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab0DVUbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:31:35 -0400
Received: from kroah.org ([198.145.64.141]:59446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721Ab0DVT7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:06 2010
Message-Id: <20100422195406.270390637@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [015/139] x86,kgdb: Always initialize the hw breakpoint attribute
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit ab310b5edb8b601bcb02491ed6f7676da4fd1757 upstream.

It is required to call hw_breakpoint_init() on an attr before using it
in any other calls.  This fixes the problem where kgdb will sometimes
fail to initialize on x86_64.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/kgdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -618,8 +618,8 @@ int kgdb_arch_init(void)
 	 * portion of kgdb because this operation requires mutexs to
 	 * complete.
 	 */
+	hw_breakpoint_init(&attr);
 	attr.bp_addr = (unsigned long)kgdb_arch_init;
-	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;


