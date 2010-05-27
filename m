Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0E0VOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:14:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab0E0VOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:14:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Thu, 27 May 2010 23:15:28 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271924170.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005271924170.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005272315.28475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Thomas Gleixner wrote:
> On Thu, 27 May 2010, Alan Stern wrote:
> 
> > On Thu, 27 May 2010, Felipe Balbi wrote:
> > 
> > > On Thu, May 27, 2010 at 05:06:23PM +0200, ext Alan Stern wrote:
> > > >If people don't mind, here is a greatly simplified summary of the
> > > >comments and objections I have seen so far on this thread:
> > > >
> > > >	The in-kernel suspend blocker implementation is okay, even
> > > >	beneficial.
> > > 
> > > I disagree here. I believe expressing that as QoS is much better. Let 
> > > the kernel decide which power state is better as long as I can say I 
> > > need 100us IRQ latency or 100ms wakeup latency.
> > 
> > Does this mean you believe "echo mem >/sys/power/state" is bad and
> > should be removed?  Or "echo disk >/sys/power/state"?  They pay no
> 
> mem should be replaced by an idle suspend to ram mechanism

Well, what about when I want the machine to suspend _regardless_ of whether
or not it's idle at the moment?  That actually happens quite often to me. :-)

> > attention to latencies or other requirements.
> 
> s2disk is a totally different beast as it shuts down the box into the
> complete power off state.

I don't see much difference between that and ACPI S3 other than the memory
contents are preserved in S3.  It also is complete power off state - except for
memory refresh and wakeup sources (which also may be active in S4).

Rafael
