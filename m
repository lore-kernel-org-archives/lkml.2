Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0KWWzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:55:39 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:59581 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0KWWzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:55:38 -0500
Date: Tue, 23 Nov 2010 23:55:27 +0100
From: mat <castet.matthieu@free.fr>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
Message-ID: <20101123235527.54293b59@mat-laptop>
In-Reply-To: <20101122164247.GC21836@basil.fritz.box>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	<1290431008.2072.119.camel@laptop>
	<1290443379.4cea9a73cd9ce@imp.free.fr>
	<1290443758.2072.318.camel@laptop>
	<20101122164247.GC21836@basil.fritz.box>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 22 Nov 2010 17:42:47 +0100,
Andi Kleen <andi@firstfloor.org> a écrit :

> > That seems to be a S3 specific code path, that won't fix anything.
> > Simply do:
> > 
> > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > 
> > and your machine will explode..
> 
> The SMP startup trampoline is copied I believe
> and only executed in real mode without page tables.
> 
> So it's perhaps not the trampoline, but the early startup 
> code that ends up being broken.
yes :
acpi wakeup code and smp trampoline are copied in low memory (first
1MB).

So they can't end up int the kernel data mapping ?

So it should something else.

I will try to investigate on this.

Matthieu
