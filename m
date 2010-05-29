Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0E2Kmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 06:42:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:51286 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0E2Kms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 06:42:48 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100529110426.077cba47@schatten.dmk.lab>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org>
	 <AANLkTimqvMuMpB5E3tj58OtlRc-7mVaec-9EHAegywg7@mail.gmail.com>
	 <1275032623.32462.30.camel@laptop> <201005290011.32543.rjw@sisk.pl>
	 <20100529110426.077cba47@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 12:42:37 +0200
Message-ID: <1275129757.27810.13205.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 11:04 +0200, Florian Mickler wrote:
> On Sat, 29 May 2010 00:11:32 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > 
> > Having reconsidered the suspend blockers idea I came to the conclusion that
> > in fact it was a workaround for three different problems.
> 
> But it is also a change of paradigm. The scheduler should strive to
> have the system idle as long as possible to conserve battery. And
> everything that does not serve the purpose of the device has to be
> considered as not worth running, except if there are other
> purpose-fullfilling tasks to run anyway.

No the purpose of the scheduler is to run tasks when they are runnable.
Not to second guess whatever caused them to become runnable.

If you start to randomly not run tasks, the inversion chaos that ensues
is terrible. You can apply the regular means of alleviating that and
that entails adding *-inheritance to all blockable resources. The -rt
patch set is doing that in part.

You really need to make applications not want to run and block on their
own volition (in a resource free point) and otherwise make them block on
something forcefully and disregard any malfunctioning that would result
from that, and in extreme cases terminate (releasing all resources).

But really Android shouldn't even need kernel support to do all this,
since its hosted on this massive middle-ware that intercepts everything,
called a Java Virtual Machine.

Now, all I'm interested in is providing interfaces from the kernel where
needed, so that userspace can be optimally frugal with power usage, and
can monitor/contain badly behaving tasks.

If Android is so set in its ways that they don't want to adopt (like
saying Android requires suspend for power management) then they can go
their own merry way and I'm not interested anymore (it would be a shame
though).


