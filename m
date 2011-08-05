Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1HEU3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:29:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50394 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab1HEU3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:29:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
Date: Fri, 5 Aug 2011 22:30:48 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1108051617430.2055-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108051617430.2055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108052230.48862.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 05, 2011, Alan Stern wrote:
> On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:
> 
> > > > I don't know how to fix it yet, but I think I know what the problem is.
> > > > Namely, a runtime suspend of the Ethernet adapter as occured in parallel with
> > > > the system-wide suspend and they clashed.  The runtime suspend has probably
> > > > been provoked by detaching the Ethernet cable from the box.
> > > 
> > > For them to clash in that way would mean that the PM workqueue didn't
> > > get frozen.
> > 
> > Not necessarily, I think.  It's sufficient that system suspend is started
> > while the runtime PM operation is in progress.
> 
> How so?  The system suspend doesn't call down to the subsystems or 
> drivers until after all the threads are frozen.  In this case the stack 
> dump shows that the runtime PM operation was asynchronous, running in a 
> workqueue thread (pm_runtime_work is one of the routines near the end 
> of the stack dump).  The thread wouldn't have frozen until the runtime 
> PM operation was complete.

You're right, sorry.  System suspend was not involved, so the problem
was triggerend by runtime suspend alone, resulting from unplugging the
Ethernet cable.

It looks like the crash started in pci_disable_msi().

Thanks,
Rafael
