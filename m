Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2CFMwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:52:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:57778 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2CFMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:52:49 -0500
Date: Tue, 6 Mar 2012 13:52:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@linux-foundation.org
cc: maglyx@gmail.com, Arnd Bergmann <arnd@arndb.de>, clemens@ladisch.de,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] hpet: factor timer allocate from open
In-Reply-To: <20120305230755.35019A02EB@akpm.mtv.corp.google.com>
Message-ID: <alpine.LFD.2.02.1203061345150.2742@ionos>
References: <20120305230755.35019A02EB@akpm.mtv.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, akpm@linux-foundation.org wrote:

> From: Magnus Lynch <maglyx@gmail.com>
> Subject: hpet: factor timer allocate from open
> 
> The current implementation of the /dev/hpet driver couples opening the
> device with allocating one of the (scarce) timers (aka comparators).  This
> is a limitation in that the main counter may be valuable to applications
> seeking a high-resolution timer who have no use for the interrupt
> generating functionality of the comparators.
> 
> This patch alters the open semantics so that when the device is opened, no
> timer is allocated.  Operations that depend on a timer being in context
> implicitly attempt allocating a timer, to maintain backward compatibility.

AFAICT, there is only fasync which calls hpet_alloc_timer(). All other
functions are broken by this chage.

>  There is also an IOCTL (HPET_ALLOC_TIMER _IO) added so that the
> allocation may be done explicitly.  (I prefer the explicit open then

And that IOCTL does what? Return 0 is not really useful functionality.

Thanks,

	tglx
