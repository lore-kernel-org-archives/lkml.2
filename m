Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031756Ab2CITxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:53:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031734Ab2CITxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:53:04 -0500
Message-Id: <20120309190218.092690160@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, <stable@kernel.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@suse.com>
Subject: [ 39/68] kprobes: adjust "fix a memory leak in function pre_handler_kretprobe()"
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jan Beulich <JBeulich@suse.com>

3.0.21's 603b63484725a6e88e4ae5da58716efd88154b1e directly used
the upstream patch, yet kprobes locking in 3.0.x uses spin_lock...()
rather than raw_spin_lock...().

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1663,9 +1663,9 @@ static int __kprobes pre_handler_kretpro
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			raw_spin_lock_irqsave(&rp->lock, flags);
+			spin_lock_irqsave(&rp->lock, flags);
 			hlist_add_head(&ri->hlist, &rp->free_instances);
-			raw_spin_unlock_irqrestore(&rp->lock, flags);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 


