Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1CAU14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:27:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51142 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757148Ab1CAU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:27:55 -0500
Date: Tue, 1 Mar 2011 15:27:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Tardy <tardyp@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC, PATCHv3 3/3] mmc: sdhci: handle wake-up from
 runtime_pm
In-Reply-To: <AANLkTikt1r3j99_ub0ce3_3snjoDXvR2+x6RxcjGfMK8@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103011525040.2034-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pierre Tardy wrote:

> >> +     if (pm_runtime_suspended()) {
> >> +             host->waking_up = 1;
> >> +             /* Note that we disable temporarly the interrupt until we do the
> >> +              * resume. If we don't then we'll get constantly interrupted
> >> +              * until we actually resume.
> >> +              *
> >> +              * as the irq is shared, this might not be very friendly to our
> >> +              * irq sharers but the pm_runtime workqueue should really be
> >> +              * called soon.
> >
> > Instead of disabling the IRQ, would it be possible to tell the device
> > to stop generating an interrupt request?
> 
> Well, the device is power gated, so any access to it will cause a bus
> timeout (depending of the platform)

But could you gate the power back on and then turn off the interrupt 
request?

It seems like a foolish design to have an interrupt request that can't
be turned off by an interrupt handler.

Alan Stern

