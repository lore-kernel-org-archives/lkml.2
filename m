Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab2I1OOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:14:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43199 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab2I1OOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:14:49 -0400
Date: Fri, 28 Sep 2012 15:13:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: anish singh <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix possible missing of device probe
Message-ID: <20120928141338.GI7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com> <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com> <20120928084626.GB7916@n2100.arm.linux.org.uk> <CACVXFVOOVvf4xOABnv1FqPOMH6_XwFcH-ZTfBDojQrZJyypT+A@mail.gmail.com> <20120928135459.GH7916@n2100.arm.linux.org.uk> <CACVXFVPs-TSoep3T_Pn3PgNEKWYSCiRNSnNOD66TcERUQJmmeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPs-TSoep3T_Pn3PgNEKWYSCiRNSnNOD66TcERUQJmmeA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:07:22PM +0800, Ming Lei wrote:
> On Fri, Sep 28, 2012 at 9:55 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >> I do not mention threads case in one CPU because the context in
> >> which device_add runs will always see the driver added into
> >
> > There you go again.  Look at my _much_ better description of the problem
> > and you'll notice that device_add has nothing to do with this.
> 
> OK, I explain it again:
> 
> CPU0						CPU1
> 
> driver_register
> 	...
> 	bus_add_driver
> 		driver_attach
> 						device_add(devb)
> 
> 		klist_add_tail(klist_drivers)
> 
> When device_add(devb) is run just after completion of driver_attach
> and before klist_add_tail(klist_drivers), the 'devb' can't be probed
> in device_add because the driver hasn't been added into bus,
> and it wasn't be probed in driver_attach because driver_attach didn't
> see the device in the bus.
> 
> So the 'devb' will be missed to be probed in the bus, won't it?

Wait a moment.  You're describing a *totally* *different* problem to
the problem I reported.  I say - for the third time - that in the
problem I reported, device_add() has NOTHING TO DO WITH IT.

In your previous mail, you complained that my description did not
cover another case.  I throw that back at you and say to you that
_your_ description does _not_ cover my case, but refers to a
_different_ problem which happens to be fixed by the _same_ fix.

To attach my "reported-by" to a problem description which is not
the problem that I reported is bad practice, and actually creates
a lie.  If you wish to keep your problem description, then you must
remove my Reported-by, because the problem you refer to in your
description is not _my_ problem.
