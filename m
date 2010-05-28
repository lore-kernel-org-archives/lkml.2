Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab0E1NsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:48:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40858 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755888Ab0E1NsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:48:06 -0400
Date: Fri, 28 May 2010 14:54:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: tytso@mit.edu, Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528145444.265d1853@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528114123.GA22947@srcf.ucam.org>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 12:41:23 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, May 28, 2010 at 10:37:13AM +0100, Alan Cox wrote:
> 
> > The other vendors appear to be managing nicely without magic blockers. I
> > conjecture therefore there are other solutions.
> 
> Actually, no. A badly behaved application will kill the N900's battery 
> life. Nobody else has "managed nicely" - they've just made life harder 
> for application developers and users, which may have something to do 
> with the relative levels of market adoption of Maemo and Android. I'm 
> not aware of any form of resource management framework in MeeGo either, 
> so as far as I know it'll have exactly the same problem.

Maemo has battery management applications. Right now they show you what
is going on but haven't gone to a pop-up 'XYZ is eating all your battery'
kill it behaviour. The information is there.

If my phone eventually becomes a 1GB RAM PC class system I will be running
PC class apps on it and I will be migrating virtual machines to and from
my phone which have no idea about the device properties of each device
they migrate to and from.

Be that as it may the question of how you manage a naughty app is a good
one. Historically we've managed them for network abuse, memory abuse, cpu
use abuse, access rights, but not yet power.

Whether that looks like

	setrlimit(pid, LIMIT_CHARGE, 150mWH);

or
	setrlimit(pid, LIMIT_POWER, 150mW);

or something else is the question. I rather like the above but I don't
see how to implement them nicely at the moment.

Alan
