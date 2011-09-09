Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1IIIZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:25:25 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:33628 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab1IIIZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:25:21 -0400
Message-ID: <e21c9efad56d1467bd3e5576da165459.squirrel@webmail.sf-mail.de>
In-Reply-To: <20110909014806.GD18249@zhy>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
    <1315383059-3673-62-git-send-email-yong.zhang0@gmail.com>
    <4E6935D9.1040104@xenotime.net> <20110909014806.GD18249@zhy>
Date: Fri, 9 Sep 2011 10:25:18 +0200
Subject: Re: [UPDATED] [PATCH 61/62] Documentation: irq: Change documents
 related to IRQF_DISABLED
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Yong Zhang" <yong.zhang0@gmail.com>
Cc: "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IRQF_DISABLED is a NOOP now, place where suggest to use this
> flag also doesn't make sense any more.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> ---
>  Documentation/PCI/MSI-HOWTO.txt  |   21 ---------------------
>  Documentation/scsi/ncr53c8xx.txt |    4 +++-
>  Documentation/scsi/tmscsim.txt   |    4 ++--
>  3 files changed, 5 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/PCI/MSI-HOWTO.txt
> b/Documentation/PCI/MSI-HOWTO.txt
> index 53e6fca..b3f514d 100644
> --- a/Documentation/PCI/MSI-HOWTO.txt
> +++ b/Documentation/PCI/MSI-HOWTO.txt
> @@ -255,27 +255,6 @@ as many vectors for MSI as it could for MSI-X.  On
> some platforms, MSI
>  interrupts must all be targeted at the same set of CPUs whereas MSI-X
>  interrupts can all be targeted at different CPUs.
>
> -4.5.2 Spinlocks
> -
> -Most device drivers have a per-device spinlock which is taken in the
> -interrupt handler.  With pin-based interrupts or a single MSI, it is not
> -necessary to disable interrupts (Linux guarantees the same interrupt will
> -not be re-entered).  If a device uses multiple interrupts, the driver
> -must disable interrupts while the lock is held.  If the device sends
> -a different interrupt, the driver will deadlock trying to recursively
> -acquire the spinlock.
> -
> -There are two solutions.  The first is to take the lock with
> -spin_lock_irqsave() or spin_lock_irq() (see
> -Documentation/DocBook/kernel-locking).  The second is to specify
> -IRQF_DISABLED to request_irq() so that the kernel runs the entire
> -interrupt routine with interrupts disabled.
> -
> -If your MSI interrupt routine does not hold the lock for the whole time
> -it is running, the first solution may be best.  The second solution is
> -normally preferred as it avoids making two transitions from interrupt
> -disabled to enabled and back again.

Is this whole section really obsolete now? Or is it only the part that
suggests IRQF_DISABLED?

Eike
