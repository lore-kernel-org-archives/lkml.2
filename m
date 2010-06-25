Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0FYNaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:30:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49091 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0FYNaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:30:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Fri, 25 Jun 2010 15:28:19 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <201006241819.25055.rjw@sisk.pl> <Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org> <20100625084056.188ba96d@schatten.dmk.lab>
In-Reply-To: <20100625084056.188ba96d@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006251528.19898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 25, 2010, Florian Mickler wrote:
> On Thu, 24 Jun 2010 13:09:27 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > > > This requires you to define an explicit PCI_WAKEUP_COOLDOWN delay.  I 
> > > > think that's okay; I had to do something similar with USB and SCSI.  
> > > > (And I still think it would be a good idea to prevent workqueue threads 
> > > > from freezing until their queues are empty.)
> 
> I'm not that familiar with the freezer, but couldn't it be
> deadlocky if the work depends on some already frozen part?

No, in the case of freezable workqueues (which is the one we're discussing)
they generally can't depend on anything freezable, because it's never known
which freezable tasks will be frozen first.

> What about a new work-type that calls
> pm_relax() after executing it's workfunction and executing
> pm_stay_awake() on enqueue?

That might be useful., although it doesn't really help here, because there
still is a window between queuing up a work item and executing it.

Rafael
