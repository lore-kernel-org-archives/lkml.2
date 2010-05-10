Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0EJTyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab0EJTyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:54:14 -0400
Date: Mon, 10 May 2010 21:51:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] INIT_SIGHAND: use SIG_DFL instead of NULL
Message-ID: <20100510195104.GE5249@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510194917.GA5249@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic, no changes in the compiled code. Just s/NULL/SIG_DFL/ to make
it more readable and grep-friendly.

Note: probably SIG_IGN makes more sense, we could kill ignore_signals().
But then kernel_init() should do flush_signal_handlers() before exec().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/init_task.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/include/linux/init_task.h~4_INIT_SIGHAND_USE_SIG_DFL	2010-05-10 20:26:08.000000000 +0200
+++ 34-rc1/include/linux/init_task.h	2010-05-10 21:06:03.000000000 +0200
@@ -43,7 +43,7 @@ extern struct nsproxy init_nsproxy;
 
 #define INIT_SIGHAND(sighand) {						\
 	.count		= ATOMIC_INIT(1), 				\
-	.action		= { { { .sa_handler = NULL, } }, },		\
+	.action		= { { { .sa_handler = SIG_DFL, } }, },		\
 	.siglock	= __SPIN_LOCK_UNLOCKED(sighand.siglock),	\
 	.signalfd_wqh	= __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
 }

