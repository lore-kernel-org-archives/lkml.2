Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0FBWGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:06:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:52371 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab0FBWGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:06:17 -0400
Date: Thu, 3 Jun 2010 08:05:56 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend.  Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
Message-ID: <20100603080556.46d2d671@notabene.brown>
In-Reply-To: <201006022241.14152.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<201006022241.14152.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 22:41:14 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 02 June 2010, Neil Brown wrote:
> > - Would this fix the "bug"??
> > - and address the issues that suspend-blockers was created to address?
> > - or are the requirements on user-space too onerous?
> 
> In theory wakeup events can also happen after  wait_for_blockers() has returned
> 0 and I guess we should rollback the suspend in such cases.
> 

I naively assumed this was already the case, but on a slightly closer look at
the code it seems not.

Presumably there is some point deep in the suspend code, probably after the
call to sysdev_suspend, where interrupts are disabled and we are about to
actually suspend.  At that point a simple "is a roll-back required" test
could abort the suspend.
Then any driver that handles wake-up events, if it gets and event that (would
normally cause a wakeup) PM_SUSPEND_PREPARE and PM_POST_SUSPEND, could set
the "roll-back is required" flag.

??

NeilBrown
