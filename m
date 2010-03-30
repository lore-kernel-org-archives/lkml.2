Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0CaALl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:11:41 -0400
Received: from kroah.org ([198.145.64.141]:51948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab0C3XR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:24 2010
Message-Id: <20100330225623.882213680@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [040/116] x86: set_personality_ia32() misses force_personality32
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 1252f238db48ec419f40c1bdf30fda649860eed9 upstream.

05d43ed8a "x86: get rid of the insane TIF_ABI_PENDING bit" forgot about
force_personality32.  Fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/process_64.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -546,6 +546,7 @@ void set_personality_ia32(void)
 
 	/* Make sure to be in 32bit mode */
 	set_thread_flag(TIF_IA32);
+	current->personality |= force_personality32;
 
 	/* Prepare the first "return" to user space */
 	current_thread_info()->status |= TS_COMPAT;


