Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0CaAg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:36:28 -0400
Received: from kroah.org ([198.145.64.141]:48580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0C3XJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:17 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:02 2010
Message-Id: <20100330225002.199228806@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jslaby@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Ollie Wild <aaw@google.com>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [34/45] x86, ia32_aout: do not kill argument mapping
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 318f6b228ba88a394ef560efc1bfe028ad5ae6b6 upstream.

Do not set current->mm->mmap to NULL in 32-bit emulation on 64-bit
load_aout_binary after flush_old_exec as it would destroy already
set brpm mapping with arguments.

Introduced by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
mm: variable length argument support
where the argument mapping in bprm was added.

[ hpa: this is a regression from 2.6.22... time to kill a.out? ]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
LKML-Reference: <1265831716-7668-1-git-send-email-jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ollie Wild <aaw@google.com>
Cc: x86@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/ia32/ia32_aout.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -324,7 +324,6 @@ static int load_aout_binary(struct linux
 	current->mm->free_area_cache = TASK_UNMAPPED_BASE;
 	current->mm->cached_hole_size = 0;
 
-	current->mm->mmap = NULL;
 	compute_creds(bprm);
 	current->flags &= ~PF_FORKNOEXEC;
 


