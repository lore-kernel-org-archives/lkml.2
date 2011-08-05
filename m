Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1HEAPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:15:16 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:54379 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab1HEAPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:15:14 -0400
Date: Fri, 5 Aug 2011 02:15:07 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110805001507.GA5987@local>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804210413.GA29222@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 12:04:13AM +0300, Michael S. Tsirkin wrote:
> On Thu, Aug 04, 2011 at 10:46:06PM +0200, Sebastian Andrzej Siewior wrote:
> > As reported by Anthony in a short way:
> > 
> > |irq 17 handler uio_interrupt+0x0/0x68 enabled interrupts
> > |NIP [c0069d84] handle_irq_event_percpu+0x260/0x26c
> > 
> > The problem here is that spin_unlock_irq() enables the interrupts which
> > is a no-no in interrupt context because they always run with interrupts
> > disabled. This is the case even if IRQF_DISABLED has not been specified
> > since v2.6.35. Therefore this patch uses simple spin_locks().
> > 
> > Looking at it further here is only one spot where the lock is hold. So
> > giving the fact that an ISR is not reentrant and is not executed on two
> > cpus at the same time why do we need a lock here?
> 
> I'm not sure anymore. I think the idea was to use
> it for synchronization down the road somehow,
> but it never materialized. Let's drop that lock completely.

That sounds reasonable.

> 
> > The driver lacks of ->irqcontrol function so I guess the interrupt is
> > enabled via direct PCI-access in userland.
> 
> Through sysfs.

How? With /sys/devices/pci.../enable ?

Thanks,
Hans
