Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab0E0VuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:50:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44502 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932723Ab0E0VuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:50:03 -0400
Date: Thu, 27 May 2010 22:56:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527225637.57a336ad@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527213635.GA9916@srcf.ucam.org>
References: <20100527155201.GA31937@srcf.ucam.org>
	<20100527171615.15a1fd3d@lxorguk.ukuu.org.uk>
	<20100527161943.GA32764@srcf.ucam.org>
	<alpine.LFD.2.00.1005271901020.3032@localhost.localdomain>
	<20100527170740.GA1980@srcf.ucam.org>
	<1274980391.27810.5552.camel@twins>
	<20100527171644.GA2468@srcf.ucam.org>
	<1274980856.27810.5582.camel@twins>
	<20100527172510.GC2468@srcf.ucam.org>
	<20100527223751.7af3b5ee@lxorguk.ukuu.org.uk>
	<20100527213635.GA9916@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 22:36:35 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 27, 2010 at 10:37:51PM +0100, Alan Cox wrote:
> > On Thu, 27 May 2010 18:25:10 +0100
> > Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > How (and why) does the WoL (which may be *any* packet, not just a magic 
> > > one) turn the screen back on?
> > 
> > Well on my laptop today it works like this
> > 
> > A WoL packet arrives
> > The CPU resumes
> > Depp process, chipset and laptop BIOS magic happens
> > The kernel gets called
> > The kernel lets interested people know a resume occurred
> 
> No it doesn't. The kernel continues executing anything that was on the 

Would you like to come and watch my laptop resume ? With printk's if you
want. You appear at this point to be arguing that bumble bees can't
fly, while watching one.

> runqueue before the scheduler stopped. If you're using idle-based 
> suspend then there's nothing on the runqueue - the application that 
> should be scheduled because of the event is blocked on writing to the 
> screen.

IFF its your bogus example
IFF you don't have any task waiting for resume notifications (ie its not
X)

So take the PC desktop case and for simplicity sake lets assume the X
application in question has either filled the socket (unlikely) or is mid
query request so blocked on the socket.

The important line then is

'The kernel lets interested people know a resume occurred'

Interesting people includes X
X therefore ends up on the runqueue
X gets the display back in order
X completes processing the outstanding X request and replies
The application continues

If I was blocked on say serial output then the resume is going to wake
the serial driver, which will transmit the queue, which will wake the app.

Alan
