Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162584Ab1FAIVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:21:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:44643 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162552Ab1FAIVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:47 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:34 2011
Message-Id: <20110601081134.410110023@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:45 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [075/165] um: Use RWSEM_GENERIC_SPINLOCK on x86
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1218
Lines: 40

From: Richard Weinberger <richard@nod.at>

commit 3a3679078aed2c451ebc32836bbd3b8219a65e01 upstream.

Commit d12337 (rwsem: Remove redundant asmregparm annotation)
broke rwsem on UML.

As we cannot compile UML with -mregparm=3 and keeping asmregparm only
for UML is inadequate the easiest solution is using RWSEM_GENERIC_SPINLOCK.

Thanks to Thomas Gleixner for the idea.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
Link: http://lkml.kernel.org/r/%3C1306183893-26655-1-git-send-email-richard%40nod.at%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/Kconfig.x86 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -29,10 +29,10 @@ config X86_64
 	def_bool 64BIT
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD
+	def_bool X86_XADD && 64BIT
 
 config RWSEM_GENERIC_SPINLOCK
-	def_bool !X86_XADD
+	def_bool !RWSEM_XCHGADD_ALGORITHM
 
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT


