Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2AaPsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:48:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2AaPsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:48:00 -0500
Date: Tue, 31 Jan 2012 10:47:48 -0500
From: Don Zickus <dzickus@redhat.com>
To: TAO HU <tghk48@motorola.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: In many cases softlockup can not be reported after disabling IRQ
 for long time
Message-ID: <20120131154748.GA5650@redhat.com>
References: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOwKts8zS1rYA+Y4k-vb8YAaR=aFd1BwryhhWWnWLQyrYrNqyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 03:28:09PM +0800, TAO HU wrote:
> Resend with a new subject
> 
> On Wed, Jan 25, 2012 at 4:24 PM, TAO HU <tghk48@motorola.com> wrote:
> > Hi, All
> >
> > While playing kernel 3.0.8 with below test code, it does NOT report
> > any softlockup with 60%~70% chances.
> > NOTE: the softlockup timeout is set to 10 seconds (i.e.
> > watchdog_thresh=5) in my test.
> > ... ...
> > preempt_disable();
> > local_irq_disable();
> > for (i = 0; i < 20; i++)
> >       mdelay(1000);
> > local_irq_enable();
> > preempt_enable();
> > ... ...
> >
> > However, if I remove local_irq_disable()/local_irq_enable() it will
> > report softlockup with no problem.
> > I believe it is due to that after local_irq_enable()
> > touch_softlockup_watchdog() is called prior softlockup timer.

Hi Hu,

Honestly, you should be getting hardlockup warnings if you are disabling
interrupts.  Do you see anything in the console output?

Cheers,
Don
