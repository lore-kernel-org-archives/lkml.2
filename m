Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0E0Vlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:41:44 -0400
Received: from www.tglx.de ([62.245.132.106]:46942 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab0E0Vln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:41:43 -0400
Date: Thu, 27 May 2010 23:40:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <201005272315.28475.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005272334040.3478@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271924170.3032@localhost.localdomain> <201005272315.28475.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Rafael J. Wysocki wrote:

> On Thursday 27 May 2010, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Alan Stern wrote:
> > 
> > > On Thu, 27 May 2010, Felipe Balbi wrote:
> > > 
> > > > On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
> > > > >If people don't mind, here is a greatly simplified summary of the
> > > > >comments and objections I have seen so far on this thread:
> > > > >
> > > > >	The in-kernel suspend blocker implementation is okay, even
> > > > >	beneficial.
> > > > 
> > > > I disagree here. I believe expressing that as QoS is much better. Let 
> > > > the kernel decide which power state is better as long as I can say I 
> > > > need 100us IRQ latency or 100ms wakeup latency.
> > > 
> > > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> > 
> > mem should be replaced by an idle suspend to ram mechanism
> 
> Well, what about when I want the machine to suspend _regardless_ of whether
> or not it's idle at the moment?  That actually happens quite often to me. :-)

Fair enough. Let's agree on a non ambigous terminology then:

     forced:

	     suspend which you enforce via user interaction, which
     	     also implies that you risk losing wakeups depending on
     	     the hardware properties

     opportunistic:

	     suspend driven from the idle context, which guarantees to
	     not lose wakeups. Provided only when the hardware does
	     provide the necessary capabilities.

Thanks,

	tglx
