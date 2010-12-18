Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0LRTNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 14:13:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50461 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0LRTND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 14:13:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Dec 2010 20:12:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded
 with "rpm_resume flags 0x4", "rpm_resume returns 1"
Message-ID: <20101218201253.167fb16a@stein>
In-Reply-To: <Pine.LNX.4.44L0.1012181311570.3334-100000@saphir.localdomain>
References: <20101217213034.7bf6587c@stein>
	<Pine.LNX.4.44L0.1012181311570.3334-100000@saphir.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18 Alan Stern wrote:
> On Fri, 17 Dec 2010, Stefan Richter wrote:
> 
> > Well right --- hald polls the card reader for media change too.
> > 
> > I now noticed that the two lines
> > 	sd *:0:0:0: rpm_resume flags 0x4
> > 	sd *:0:0:0: rpm_resume returns 1
> > are logged once for each sd device (i.e. those with fixed media too)
> > at the startup of hald.  Is this expected?
> 
> I don't know anything about the details of hal.  But I do know that you
> can tell hal not to poll certain devices.  Look at "man
> hal-disable-polling".

I wouldn't use hal at all if it weren't for some weak userland
programs that require it.

> > Note, I have not seen anything of the sort on another PC which runs
> > 2.3.37-rc6 with the same PM debug options.  The differences are that
> > the other PC is an Intel 945GM based one with x86-32 kernel and 32bit
> > Gentoo userland, whereas the PC with log spam is an AMD RS780 based one
> > with x86-64 kernel and 64bit Gentoo userland.  Both got hal 0.5.14-r2.
> 
> Maybe CONFIG_DYNAMIC_DEBUG is set differently, or userspace enables 
> dynamic debugging of different subsystems.

Simpler:  I am now noticing that CONFIG_PM_RUNTIME is off on the silent
PC.  It is only on on the PC which produces the log spam.

Good.  Then the solution for me is simply to disable CONFIG_PM_RUNTIME,
which I had switched on for no apparent reason.
-- 
Stefan Richter
-=====-==-=- ==-- =--=-
http://arcgraph.de/sr/
