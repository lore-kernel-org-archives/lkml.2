Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab0KYFfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 00:35:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57734 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KYFfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 00:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Sqd8Cd8nVhrc6VInWrIHL1YNRE785Bxm7pVMHBAa0ehW3yb9HcTucK7BMY6liwzldH
         GX8BHUR56aIhXM4moCG+AcfA+rluKP0AomXhHj1Mh5oaxNgBulTrGQVdTAxZGdOX1Q8T
         InGiy2ESb2OmnRCSZVYbKNIIV/JeUXiJJdFR4=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0iWzP4KwVwpY4bDJuyZnQTFnW0Q5pj3TM-s_O@mail.gmail.com>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<AANLkTik0iWzP4KwVwpY4bDJuyZnQTFnW0Q5pj3TM-s_O@mail.gmail.com>
Date: Thu, 25 Nov 2010 11:35:16 +0600
Message-ID: <AANLkTik9U_Z0WSZ7YjrykER_pBUfPDdgUUmtYx=R74nL@mail.gmail.com>
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, sandmann@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 7:19 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2010/11/24 Rakib Mullick <rakib.mullick@gmail.com>:
>
> Looks like you can even remove that block. bp is not used any more in
> this function.
> get_bp() was only loading bp but did not make any use of it.

Yes, right. Here is the updated one.

 In dump_stack function, bp isn't used anymore, which is introduced by
commit 9c0729dc8062bed96189bd14ac6d4920f3958743. This patch removes bp
completely.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 8474c99..d6fb146 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -197,14 +197,8 @@ void show_stack(struct task_struct *task,
unsigned long *sp)
  */
 void dump_stack(void)
 {
-	unsigned long bp = 0;
 	unsigned long stack;

-#ifdef CONFIG_FRAME_POINTER
-	if (!bp)
-		get_bp(bp);
-#endif
-
 	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,


>
> Thanks.
>
