Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2JHS7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:59:14 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46830 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab2JHS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121007191627.GA19278@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net>
	<20121007165534.GA8024@redhat.com>
	<20121007171300.GA10942@redhat.com>
	<20121007180420.GA900@ds20.borg.net>
	<20121007191627.GA19278@redhat.com>
Date: Mon, 8 Oct 2012 20:59:10 +0200
X-Google-Sender-Auth: 01UjCNg3KuAlXwWLxO6rBRaij-o
Message-ID: <CAMuHMdUjqogJ5Db1wCZz4v6OEutDPbcF0a=zc=ZCJS7-8rYDqw@mail.gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 9:16 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 10/07, Thorsten Kranzkowski wrote:
>> On Sun, Oct 07, 2012 at 07:13:00PM +0200, Oleg Nesterov wrote:
>> > On 10/07, Oleg Nesterov wrote:
>> > > Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
>> > > But _it seems_ to me that do_notify_resume() is called with irqs disabled.
>> > > If this is true, then imho arch/alpha should be fixed.
>> > >
>> > > Before this commit task_work_run() enabled irqs, but this was the "side
>> > > effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.
>> >
>> > Could you please test the debugging patch below?
>>
>> Of course. With that patch applied the kernel (ac3d0da) boots again. The trace line
>> is printed about once a second, with values '2' and '4'.
>
> Thanks a lot Thorsten!
>
> So I'll probably send the patch which enables interrupts in
> task_work_run(). I guess this needs "if (irqs_disabled())"
> for lockdep.
>
> The question is, should I add the warning to remind that this
> arch needs a fix?

Just wondering. As this is on an SMP system, perhaps the
read_barrier_depends() vs. smp_read_barrier_depends() matters
here?
http://lkml.indiana.edu/hypermail/linux/kernel/1209.3/00555.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
