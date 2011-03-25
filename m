Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab1CZAS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:18:28 -0400
Received: from kroah.org ([198.145.64.141]:41772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab1CYXwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:42 2011
Message-Id: <20110325234842.544666587@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Engraf <david.engraf@sysgo.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [34/55] sh: Fix ptrace hw_breakpoint handling
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Engraf <david.engraf@sysgo.com>

commit fb7f045ace0624f1e59a7db8497e460bd54b1cbc upstream.

Since commit 34d0b5af50a063cded842716633501b38ff815fb it is no longer
possible to debug an application using singlestep. The old commit
converted singlestep handling via ptrace to hw_breakpoints. The
hw_breakpoint is disabled when an event is triggered and not re-enabled
again. This patch re-enables the existing hw_breakpoint before the
existing breakpoint is reused.

Signed-off-by: David Engraf <david.engraf@sysgo.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/kernel/ptrace_32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -101,6 +101,8 @@ static int set_single_step(struct task_s
 
 		attr = bp->attr;
 		attr.bp_addr = addr;
+		/* reenable breakpoint */
+		attr.disabled = false;
 		err = modify_user_hw_breakpoint(bp, &attr);
 		if (unlikely(err))
 			return err;


