Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1HWAzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:55:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50411 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754613Ab1HWAzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:55:47 -0400
X-Sasl-enc: uAo4aXbRHOyq9oqAIiZ4R41uYeQVTE3j9IZt7csRdy5e 1314060946
Date: Mon, 22 Aug 2011 17:49:43 -0700
From: Greg KH <greg@kroah.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Chris Wright <chrisw@redhat.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110823004943.GB29215@kroah.com>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805001507.GA5987@local>
 <20110808062431.GB5182@redhat.com>
 <20110808171931.GB867@local>
 <20110809113743.GA32299@redhat.com>
 <20110809185341.GD4229@local>
 <20110810084012.GD13911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810084012.GD13911@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:40:12AM +0300, Michael S. Tsirkin wrote:
> On Tue, Aug 09, 2011 at 08:53:41PM +0200, Hans J. Koch wrote:
> > On Tue, Aug 09, 2011 at 02:37:43PM +0300, Michael S. Tsirkin wrote:
> > > > 
> > > > Should I hack up a patch to remove the lock, or do you have anything in your
> > > > pipeline?
> > > 
> > > 
> > > Please do.
> > > 
> > 
> > Here it is:
> > 
> > Greg (and anyone else...), you can also pull this from branch "uio-for-greg" from
> > 
> > git://hansjkoch.de/git/linux-hjk
> > 
> > 
> > >From ff74627ade002d40fe1f902b7aadab8b1f15f889 Mon Sep 17 00:00:00 2001
> > From: "Hans J. Koch" <hjk@hansjkoch.de>
> > Date: Tue, 9 Aug 2011 20:34:31 +0200
> > Subject: [PATCH] uio: uio_pci_generic: Remove useless spin_lock
> > 
> > The spin_lock in uio_pci_generic.c is only used in the interrupt
> > handler, which cannot be executed twice at the same time.
> > That makes the lock rather pointless. This patch removes it.
> > 
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Chris Wright <chrisw@redhat.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Cc: Anthony Foiani <anthony.foiani@gmail.com>
> > Reported-by: Anthony Foiani <anthony.foiani@gmail.com>
> > Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> 
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I also suggest this for the stable trees.

Why, it's not fixing a bug that anyone hits, right?

greg k-h
