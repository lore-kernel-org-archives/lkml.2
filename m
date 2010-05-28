Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0E1ADz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:03:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50526 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0E1ADx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:03:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 28 May 2010 02:05:01 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <201005280041.43553.rjw@sisk.pl> <20100528001514.28e593ef@lxorguk.ukuu.org.uk>
In-Reply-To: <20100528001514.28e593ef@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280205.01561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010, Alan Cox wrote:
> > The approach with user space power manager suggested by Dmitry and Alan Stern
> > may work, but it still assumes some kind of suspend blockers to be present in
> > the kernel.  If we reject that too, I wonder what approach Google is supposed
> > to use and still get the same battery life they get with suspend blockers.
> 
> I'm getting less convinced it needs suspend blockers at all for this case,
> assuming that you are willing to have a policy that is based on
> 
> - assuming apps play nicely
> - having the information to user space you need (who woke us, who blocked
>   us, events)
> - dealing with offenders primarily from user space using that information
> 
> I'm fairly happy about the following so far
> 
> - we should have a common interface for seeing some pm events (like
>   duh ?) but it does need careful thought so the watcher doesn't change
>   the behaviour and break it. (Message "We are suspending", gosh someone
>   is running to receive the message, resume being the obvious case)
> 
> - Suspend is (for many platforms) just a cotinuation down the power
>   chain. Demonstrated and implemented on ARM. Very much the direction of
>   S0i1/S0i3 on x86 MID devices. Proved by the fact it has been done and
>   made to work, and by reading the Moorestown PR.
> 
> - Given a non forced (that is 'idle down') transition to a suspend level
>   we can implement a 'suspend as idle' on many embedded platforms in a
>   manner which is not racy at kernel level. Apparently implemented
>   already on ARM
> 
> - Given a non forced transition to such a suspend level and the reporting
>   of certain events we can do a full user space managed graphical UI type
>   environment policy in a race free fashion
> 
> - With notification of who caused a resume and maybe a bit of other
>   general stat gathering it is possible to identify and handle abuses of
>   power resource. Proved by the fact we can do this with powertop but
>   more elegance in the interfaces would be nice.
> 
> I am not sure if a pm event is what is needed for this or a sum 'hardware
> triggered wake up' event.
> 
> I accept that current ACPI based laptops probably couldn't make use of
> such a feature but I don't think this is important at the moment.

No, it's not.

> A resource constraint model might help further in the ACPI case. It's
> useful for other stuff but it might well be a distraction and
> implementation detail in terms of the basic question about what is needed
> for something like Android.
> 
> At this point the input of the Android team and the Nokia people would
> be rather more useful to me.

OK, I added Arve and Brian to the CC list.

Thanks,
Rafael
