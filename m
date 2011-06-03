Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1FCNGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:06:03 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:54269 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1FCNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:06:00 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DE8DC28.30709@die-jansens.de>
Date: Fri, 03 Jun 2011 15:05:44 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152729.232781355@chello.nl> <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org> <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop> <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop> <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de> <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de> <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
In-Reply-To: <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.06.2011 14:44, Linus Torvalds wrote:
> On Fri, Jun 3, 2011 at 7:02 PM, Arne Jansen <lists@die-jansens.de> wrote:
>>
>> No, it doesn't trigger, but the hang is not as complete as I first
>> thought. A running iostat via ssh continues to give output for a while,
>> the serial console still reacts to return and prompts for login. But
>> after a while more and more locks up. The console locks as soon as I
>> sysrq-t.
> 
> Is it the tty rescheduling bug?
> 
> That would explain the printk's mattering.
> 
> Remove the schedule_work() call from flush_to_ldisc() in
> drivers/tty/tty_buffer.c and see if the problem goes away. See the
> other discussion thread on lkml ("tty breakage in X (Was: tty vs
> workqueue oddities)")
> 
> Hmm?

No change. Also git bisect quite clearly points to
0122ec5b02f766c and ab2515c4b98f7bc4, both are older than
b1c43f82c5aa2654 mentioned in the other thread.

-Arne


>                    Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

