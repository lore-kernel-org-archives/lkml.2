Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1HWIkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:40:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:45264 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1HWIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:40:11 -0400
Date: Tue, 23 Aug 2011 10:40:05 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg KH <greg@kroah.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Chris Wright <chrisw@redhat.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110823084005.GB20979@linutronix.de>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805001507.GA5987@local>
 <20110808062431.GB5182@redhat.com>
 <20110808171931.GB867@local>
 <20110809113743.GA32299@redhat.com>
 <20110809185341.GD4229@local>
 <20110810084012.GD13911@redhat.com>
 <20110823004943.GB29215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110823004943.GB29215@kroah.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH | 2011-08-22 17:49:43 [-0700]:

>> > Cc: Anthony Foiani <anthony.foiani@gmail.com>
>
>Why, it's not fixing a bug that anyone hits, right?

"earlier" the interrupt handler was executed either with interrupts
enabled or disabled if IRQF_DISABLED was specified. Later the latter
become default even if IRQF_DISABLED was not specified. This lead to the
splat Anthony reported because the irq handler was entered with IRQs
disabled and the ISR enabled them via spin_unlock_irq(). My initial
patch simply used spin_unlock_irqrestore() (and its counterpart) to have
the same state as we had.

So the bug Anthony hit was that the interrupts were enabled where they
should not be.

>greg k-h

Sebastian
