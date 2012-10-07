Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2JGTPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 15:15:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab2JGTPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 15:15:05 -0400
Date: Sun, 7 Oct 2012 21:16:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121007191627.GA19278@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121007165534.GA8024@redhat.com> <20121007171300.GA10942@redhat.com> <20121007180420.GA900@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007180420.GA900@ds20.borg.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Thorsten Kranzkowski wrote:
>
> On Sun, Oct 07, 2012 at 07:13:00PM +0200, Oleg Nesterov wrote:
> > On 10/07, Oleg Nesterov wrote:
> > >
> > > Hmm. I know nothing about arch/alpha and I can't understand its entry.S.
> > > But _it seems_ to me that do_notify_resume() is called with irqs disabled.
> > > If this is true, then imho arch/alpha should be fixed.
> > >
> > > Before this commit task_work_run() enabled irqs, but this was the "side
> > > effect" of spin_lock_irq/spin_unlock_irq, we should not rely on this.
> >
> > Could you please test the debugging patch below?
>
> Of course. With that patch applied the kernel (ac3d0da) boots again. The trace line
> is printed about once a second, with values '2' and '4'.

Thanks a lot Thorsten!

So I'll probably send the patch which enables interrupts in
task_work_run(). I guess this needs "if (irqs_disabled())"
for lockdep.

The question is, should I add the warning to remind that this
arch needs a fix?

Oleg.

