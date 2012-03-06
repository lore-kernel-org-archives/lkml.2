Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032Ab2CFSiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:38:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964947Ab2CFSiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:38:06 -0500
Date: Tue, 6 Mar 2012 10:38:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, maglyx@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] hpet: factor timer allocate from open
Message-Id: <20120306103805.5d8e0d09.akpm@linux-foundation.org>
In-Reply-To: <4F562775.2010501@ladisch.de>
References: <20120305230755.35019A02EB@akpm.mtv.corp.google.com>
	<alpine.LFD.2.02.1203061345150.2742@ionos>
	<4F562775.2010501@ladisch.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2012 16:04:21 +0100
Clemens Ladisch <clemens@ladisch.de> wrote:

> Thomas Gleixner wrote:
> > On Mon, 5 Mar 2012, akpm@linux-foundation.org wrote:
> >> From: Magnus Lynch <maglyx@gmail.com>
> >> Subject: hpet: factor timer allocate from open
> >>
> >> The current implementation of the /dev/hpet driver couples opening the
> >> device with allocating one of the (scarce) timers (aka comparators).  This
> >> is a limitation in that the main counter may be valuable to applications
> >> seeking a high-resolution timer who have no use for the interrupt
> >> generating functionality of the comparators.
> >>
> >> This patch alters the open semantics so that when the device is opened, no
> >> timer is allocated.  Operations that depend on a timer being in context
> >> implicitly attempt allocating a timer, to maintain backward compatibility.
> >
> > AFAICT, there is only fasync which calls hpet_alloc_timer(). All other
> > functions are broken by this chage.
> 
> Indeed.  There was another call in hpet_ioctl_common(), but it appears
> that one somehow got dropped.
> 
> Magnus, is this the patch that you submitted and have tested?

I've been carrying this patch since March 2010 - perhaps it rotted.
