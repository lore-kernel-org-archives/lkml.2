Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1IIIlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:41:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47811 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1IIIl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:41:29 -0400
Date: Fri, 9 Sep 2011 16:41:18 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [UPDATED] [PATCH 61/62] Documentation: irq: Change documents
 related to IRQF_DISABLED
Message-ID: <20110909084118.GA21958@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
 <4E6935D9.1040104@xenotime.net>
 <20110909014806.GD18249@zhy>
 <e21c9efad56d1467bd3e5576da165459.squirrel@webmail.sf-mail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e21c9efad56d1467bd3e5576da165459.squirrel@webmail.sf-mail.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 10:25:18AM +0200, Rolf Eike Beer wrote:
> > IRQF_DISABLED is a NOOP now, place where suggest to use this
> > flag also doesn't make sense any more.
> >
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > ---
> >  Documentation/PCI/MSI-HOWTO.txt  |   21 ---------------------
> >  Documentation/scsi/ncr53c8xx.txt |    4 +++-
> >  Documentation/scsi/tmscsim.txt   |    4 ++--
> >  3 files changed, 5 insertions(+), 24 deletions(-)
> >
> > diff --git a/Documentation/PCI/MSI-HOWTO.txt
> > b/Documentation/PCI/MSI-HOWTO.txt
> > index 53e6fca..b3f514d 100644
> > --- a/Documentation/PCI/MSI-HOWTO.txt
> > +++ b/Documentation/PCI/MSI-HOWTO.txt
> > @@ -255,27 +255,6 @@ as many vectors for MSI as it could for MSI-X.  On
> > some platforms, MSI
> >  interrupts must all be targeted at the same set of CPUs whereas MSI-X
> >  interrupts can all be targeted at different CPUs.
> >
> > -4.5.2 Spinlocks
> > -
> > -Most device drivers have a per-device spinlock which is taken in the
> > -interrupt handler.  With pin-based interrupts or a single MSI, it is not
> > -necessary to disable interrupts (Linux guarantees the same interrupt will
> > -not be re-entered).  If a device uses multiple interrupts, the driver
> > -must disable interrupts while the lock is held.  If the device sends
> > -a different interrupt, the driver will deadlock trying to recursively
> > -acquire the spinlock.
> > -
> > -There are two solutions.  The first is to take the lock with
> > -spin_lock_irqsave() or spin_lock_irq() (see
> > -Documentation/DocBook/kernel-locking).  The second is to specify
> > -IRQF_DISABLED to request_irq() so that the kernel runs the entire
> > -interrupt routine with interrupts disabled.
> > -
> > -If your MSI interrupt routine does not hold the lock for the whole time
> > -it is running, the first solution may be best.  The second solution is
> > -normally preferred as it avoids making two transitions from interrupt
> > -disabled to enabled and back again.
> 
> Is this whole section really obsolete now? Or is it only the part that
> suggests IRQF_DISABLED?

The whole paragraph is about how to avoid the deadlock when we handle an
interrupt another is rising. And the two solutions both intend to
disable irqs. But it is implied by current genirq (genirq will keep
irqs disabled when calling the action handler).

So IMHO, we need not to mention the spinlock any more.

Thanks,
Yong

> 
> Eike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
