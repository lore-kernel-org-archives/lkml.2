Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0FDPnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 11:43:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54990 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0FDPnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 11:43:43 -0400
Date: Fri, 4 Jun 2010 17:43:28 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100604174328.30b26b6a@schatten.dmk.lab>
In-Reply-To: <1275578881.27810.35995.camel@twins>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<201005302202.39511.rjw@sisk.pl>
	<AANLkTilUQ2AG76nbK6LwI8_7zw0_yMSoAOr9pmuz7xrt@mail.gmail.com>
	<201005312347.24251.rjw@sisk.pl>
	<AANLkTilvOgSFTDFtXbjJobMZWxgfvsC97TqC7_a_NHBX@mail.gmail.com>
	<alpine.LFD.2.00.1006011411200.2933@localhost.localdomain>
	<AANLkTikZHmF6baP7dEXEGFE8YsbEteRjlhb5wqZX8ll1@mail.gmail.com>
	<alpine.LFD.2.00.1006020905410.2933@localhost.localdomain>
	<AANLkTinDm3FIrbS1jqEzW15THmr1hdd7ox0Mllm1VLjZ@mail.gmail.com>
	<1275471561.27810.30865.camel@twins>
	<AANLkTilLmAb2c9fQwuguzWtjcHfuTZvPUTbUx7vuwFI6@mail.gmail.com>
	<1275474088.27810.31000.camel@twins>
	<20100602221309.6da754e7@schatten.dmk.lab>
	<1275550802.27810.34863.camel@twins>
	<20100603161205.73a2b56d@schatten.dmk.lab>
	<1275578881.27810.35995.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 17:28:01 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-06-03 at 16:12 +0200, Florian Mickler wrote:
> > On Thu, 03 Jun 2010 09:40:02 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Same for firefox, you can teach it to not render animated gifs and run
> > > javascript for invisible tabs, and once the screen-saver kicks in,
> > > nothing is visible (and with X telling apps their window is visible or
> > > not it knows), so it should go idle all of its own.
> > > 
> > > Fix the friggin apps, don't kludge with freezing.
> > 
> > Of course programs should be as smart as possible. But that is an
> > orthogonal problem.
> > 
> > Suppose firefox were fixed. It still needs to fetch my rss feeds every
> > minute, because I'm sad if it doesn't. It just can't be fixed at the
> > application level.
> 
> Sure it can, why would it need to fetch RSS feeds when the screen is off
> and nobody could possible see the result? So you can stop the timer when
> you know the window isn't visible or alternatively when the screensaver
> is active, I think most desktops have notification of that as well.

This is arguing on a very thin line. In fact it is becoming pointless. 

Suppose there were an RSS-feed plugin that signals events to an event
Plugin. That event plugin could be either visual notification or sending
audio-signals. But the RSS feed doesn't know what specific plugin it
talks to. So screen off is _not always_ the right indicator. Sometimes
it is, sometimes it's not. 
There would be a seperate infrastructure needed in the program to tell
the different plugins that the core thinks everything should stop.
How does the core knows when to stop? And then there probably need to
be some kind of "suspend blockers" in the program. *g*

Just solve it at the right level, so that the apps don't need to be
infected with this shit. And this belongs between the iron and the
apps. And it seems it needs to be some cooperative approach of kernel
and userspace-framework as it isn't right to put that much policy in
the kernel.

I don't think it is a black and white thing, where you can just say
"fix the friggin apps". 

And this is a really f*beep*ng serious point. (at least to me)

Cheers,
Flo

