Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0FYGln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:41:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54830 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0FYGll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:41:41 -0400
Date: Fri, 25 Jun 2010 08:40:56 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [update 2] Re: [RFC][PATCH] PM: Avoid losing wakeup events
 during suspend
Message-ID: <20100625084056.188ba96d@schatten.dmk.lab>
In-Reply-To: <Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org>
References: <201006241819.25055.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1006241257410.1654-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 13:09:27 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> > > This requires you to define an explicit PCI_WAKEUP_COOLDOWN delay.  I 
> > > think that's okay; I had to do something similar with USB and SCSI.  
> > > (And I still think it would be a good idea to prevent workqueue threads 
> > > from freezing until their queues are empty.)

I'm not that familiar with the freezer, but couldn't it be
deadlocky if the work depends on some already frozen part?

What about a new work-type that calls
pm_relax() after executing it's workfunction and executing
pm_stay_awake() on enqueue?


Cheers,
Flo
