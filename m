Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1FCMo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:44:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab1FCMoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:44:25 -0400
MIME-Version: 1.0
In-Reply-To: <4DE8B13D.9020302@die-jansens.de>
References: <20110405152729.232781355@chello.nl> <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins>
 <4DE8B13D.9020302@die-jansens.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Jun 2011 21:44:01 +0900
Message-ID: <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 7:02 PM, Arne Jansen <lists@die-jansens.de> wrote:
>
> No, it doesn't trigger, but the hang is not as complete as I first
> thought. A running iostat via ssh continues to give output for a while,
> the serial console still reacts to return and prompts for login. But
> after a while more and more locks up. The console locks as soon as I
> sysrq-t.

Is it the tty rescheduling bug?

That would explain the printk's mattering.

Remove the schedule_work() call from flush_to_ldisc() in
drivers/tty/tty_buffer.c and see if the problem goes away. See the
other discussion thread on lkml ("tty breakage in X (Was: tty vs
workqueue oddities)")

Hmm?

                   Linus
