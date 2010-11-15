Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab0KOOqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:46:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35217 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab0KOOqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version
         :to:cc:subject:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QiRfJzEXW4tBl4PqabddVFPJ38H3/kBUDNKpp+iquoMaXqU31HFtIP68b5dFSNbqdt
         viJgh8cenkydO13/5qlR5VmFxVuztuhzAWwB9lxo3SdeEqsWburO5diSzNeyr4bA8rww
         5/tn9Of9o1XC9i2z3ca9R5wWs8JoYAa11H2vA=
Message-ID: <4CE147AE.2030102@gmail.com>
Date: Mon, 15 Nov 2010 20:16:06 +0530
From: Atul Sowani <sowani@gmail.com>
Reply-To: sowani@gmail.com
Organization: Digital Reality Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan@linux.intel.com, ralf@linux-mips.org, u.kleine-koenig@pengutronix.de,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 2.6.36 1/1 RESEND] kernel SPIN_LOCK_UNLOCKED changed to
 __SPIN_LOCK_UNLOCKED()
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are still some files containing .lock = SPIN_LOCK_UNLOCKED type
assignments which should be converted to __SPIN_LOCK_UNLOCKED().
--- Corrected spacing between __SPIN_LOCK_UNLOCKED and ( for ARM.
--- Resubmitting the patch with spacing fixes.
--- Removed ARM related changes after Russell King's NACK.

Signed-off-by: Atul Sowani <sowani@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---

diff -uprN a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c	2010-10-21 02:00:22.000000000 +0530
+++ b/arch/mips/kernel/vpe.c	2010-11-07 00:51:37.000000000 +0530
@@ -148,9 +148,9 @@ struct {
 	spinlock_t tc_list_lock;
 	struct list_head tc_list;	/* Thread contexts */
 } vpecontrol = {
-	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
+	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.vpe_list_lock),
 	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
-	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
+	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(vpecontrol.tc_list_lock),
 	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
 };
diff -uprN a/kernel/cred.c b/kernel/cred.c
--- a/kernel/cred.c	2010-10-21 02:00:22.000000000 +0530
+++ b/kernel/cred.c	2010-11-07 00:52:22.000000000 +0530
@@ -35,7 +35,7 @@ static struct kmem_cache *cred_jar;
 static struct thread_group_cred init_tgcred = {
 	.usage	= ATOMIC_INIT(2),
 	.tgid	= 0,
-	.lock	= SPIN_LOCK_UNLOCKED,
+	.lock	= __SPIN_LOCK_UNLOCKED(init_tgcred.lock),
 };
 #endif
-- 
Atul Sowani (sowani@gmail.com)
http://savannah.gnu.org/users/atul
------------------------------------------------------------------------
