Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1HWLAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:00:32 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:48931 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1HWLA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:00:28 -0400
Date: Tue, 23 Aug 2011 13:00:01 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg KH <greg@kroah.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Chris Wright <chrisw@redhat.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110823110001.GB29209@local>
References: <20110804210413.GA29222@redhat.com>
 <20110805001507.GA5987@local>
 <20110808062431.GB5182@redhat.com>
 <20110808171931.GB867@local>
 <20110809113743.GA32299@redhat.com>
 <20110809185341.GD4229@local>
 <20110810084012.GD13911@redhat.com>
 <20110823004943.GB29215@kroah.com>
 <20110823084005.GB20979@linutronix.de>
 <20110823105727.GA29209@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823105727.GA29209@local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:57:42PM +0200, Hans J. Koch wrote:
> On Tue, Aug 23, 2011 at 10:40:05AM +0200, Sebastian Andrzej Siewior wrote:
> > * Greg KH | 2011-08-22 17:49:43 [-0700]:
> > 
> > >> > Cc: Anthony Foiani <anthony.foiani@gmail.com>
> > >
> > >Why, it's not fixing a bug that anyone hits, right?
> > 
> > "earlier" the interrupt handler was executed either with interrupts
> > enabled or disabled if IRQF_DISABLED was specified. Later the latter
> > become default even if IRQF_DISABLED was not specified. This lead to the
> > splat Anthony reported because the irq handler was entered with IRQs
> > disabled and the ISR enabled them via spin_unlock_irq(). My initial
> > patch simply used spin_unlock_irqrestore() (and its counterpart) to have
> > the same state as we had.
> > 
> > So the bug Anthony hit was that the interrupts were enabled where they
> > should not be.
> > 
> > >greg k-h
> > 
> > Sebastian
> > 
> 
> Greg, I'll change the commit message so that it becomes clear, and send
> you a pull request.
> 
> There is also one more UIO patch pending. Do you want a separate branch
> for -stable, or can you cherry-pick that from one UIO branch?

Forget it, I just saw you already added it to your tree.

Thanks,
Hans
