Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1HFTfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:35:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537Ab1HFTfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:35:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Crash when suspending Lenovo T510 laptop (2.6.39.3)
Date: Sat, 6 Aug 2011 21:36:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1108051641040.2055-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108051641040.2055-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108062136.59218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 05, 2011, Alan Stern wrote:
> On Fri, 5 Aug 2011, Rafael J. Wysocki wrote:
> 
> > > You're right, sorry.  System suspend was not involved, so the problem
> > > was triggerend by runtime suspend alone, resulting from unplugging the
> > > Ethernet cable.
> > > 
> > > It looks like the crash started in pci_disable_msi().
> > 
> > OTOH, I'm not sure how pci_legacy_suspend_late() was called.
> > In theory it is only called by the system suspend code and it surely
> > is not called for e1000e.
> 
> The ? indicates that pci_legacy_suspend_late() wasn't necessarily on
> the task's call stack; it may simply have been a leftover pointer from
> some other operation, sitting somewhere in the middle of the stack
> page.

However, Jesper said the crash happend during suspend, so I wonder how
that might be present on the stack while executing runtime PM routines?

Rafael
