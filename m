Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab0JSVIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:08:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0JSVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:08:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Tue, 19 Oct 2010 23:08:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: "Ohad Ben-Cohen" <ohad@wizery.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <201010191921.21007.arnd@arndb.de> <AANLkTinXR7OcfTpA6cWhRGzceekD6KQgnxOLeBKXP3WB@mail.gmail.com>
In-Reply-To: <AANLkTinXR7OcfTpA6cWhRGzceekD6KQgnxOLeBKXP3WB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192308.02018.arnd@arndb.de>
X-Provags-ID: V02:K0:musnWT2vCJjPyNAxHJjkBoakUgpjJ/iYjEjDWtIIYDw
 0Ug7beAplE+2YDJE/OU1pGzrsv38MjSLLVi5LXJ3RS634wnEud
 dq2pIEVLZEdXtsZONd/x1wausw8EUA1JmDNrLwgT0UUwfKKFGT
 RresY2muiQqzZVVm17J6Sa11I1o9pq13BO4/ChtLp7x9E/GVxX
 f1zmz8UmxR1jOAEtm9bkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010 22:51:22 Ohad Ben-Cohen wrote:
> >, which is generally discouraged
> > in all places where you know if you need to disable interrupts or not.
> >
> > IMHO the default should be a version that only allows locks that don't get
> > taken at IRQ time and consequently don't require saving the interrupt flags.
> 
> Please note that the hwspinlocks should never be used to achieve
> synchronization with Linux contexts running on the same cpu - it's
> always about achieving mutual exclusion with a remote processor.

Ok, I see.
 
> So whether the lock is taken at IRQ time or not does not affect the
> requirement to disable interrupts while it is taken (very differently
> from local spin_lock{_irqsave} synchronizations).

Right. There are two more things to consider though:

If you know that interrupts are disabled, you may still want to avoid
having to save the interrupt flag to the stack, to save some cycles
saving and restoring it. I don't know how expensive that is on ARM,
some other architectures take an microseconds to restore the interrupt
enabled flag from a register.

Even in the case where you know that interrupts are enabled, you may
want to avoid saving the interrupt flag to the stack, the simpler
API (one argument instead of two) gives less room for screwing up.

	Arnd
