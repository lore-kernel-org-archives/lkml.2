Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2ASAFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:05:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab2ASAFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:05:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Simon Glass <sjg@chromium.org>
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Date: Thu, 19 Jan 2012 01:08:32 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-serial@vger.kernel.org
References: <1326826563-32215-1-git-send-email-sjg@chromium.org> <20120118041720.GA2431@linux.vnet.ibm.com> <CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
In-Reply-To: <CAPnjgZ1GJatR15dVsq-+hAWhD7eaLhtN737QvBaor_=0+K+6wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201190108.32794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 18, 2012, Simon Glass wrote:
> [+cc Rafael J. Wysocki <rjw@sisk.pl> who I think wrote the wakeup.c code]
> 
> Hi Alan, Paul,
> 
> On Tue, Jan 17, 2012 at 8:17 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Jan 17, 2012 at 08:10:36PM +0000, Alan Cox wrote:
> >> On Tue, 17 Jan 2012 10:56:03 -0800
> >> Simon Glass <sjg@chromium.org> wrote:
> >>
> >> > Since serial_core now does not make serial ports wake-up capable by
> >> > default, add a parameter to support this feature in the 8250 UART.
> >> > This is the only UART where I think this feature is useful.
> >>
> >> NAK
> >>
> >> Things should just work for users. Magic parameters is not an
> >> improvement. If its a performance problem someone needs to fix the rcu
> >> sync overhead or stop using rcu on that path.
> 
> OK fair enough, I agree. Every level I move down the source tree
> affects more people though.
> 
> >
> > I must say that I lack context here, even after looking at the patch,
> > but the synchronize_rcu_expedited() primitives can be used if the latency
> > of synchronize_rcu() is too large.
> >
> 
> Let me provide a bit of context. The serial_core code seems to be the
> only place in the kernel that does this:
> 
> 		device_init_wakeup(tty_dev, 1);
> 		device_set_wakeup_enable(tty_dev, 0);

It shouldn't do that.

It should just do device_set_wakeup_capable(tty_dev, true) instead.

Thanks,
Rafael
