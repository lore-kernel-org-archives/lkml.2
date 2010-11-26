Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0KZRbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:31:55 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:55741 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab0KZRby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:31:54 -0500
Date: Fri, 26 Nov 2010 18:31:44 +0100
From: mat <castet.matthieu@free.fr>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection
 for kernel data)
Message-ID: <20101126183144.300a71a4@mat-laptop>
In-Reply-To: <20101123235527.54293b59@mat-laptop>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	<1290431008.2072.119.camel@laptop>
	<1290443379.4cea9a73cd9ce@imp.free.fr>
	<1290443758.2072.318.camel@laptop>
	<20101122164247.GC21836@basil.fritz.box>
	<20101123235527.54293b59@mat-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 23 Nov 2010 23:55:27 +0100,
mat <castet.matthieu@free.fr> a écrit :

> Le Mon, 22 Nov 2010 17:42:47 +0100,
> Andi Kleen <andi@firstfloor.org> a écrit :
> 
> > > That seems to be a S3 specific code path, that won't fix anything.
> > > Simply do:
> > > 
> > > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > > 
> > > and your machine will explode..
> > 
> > The SMP startup trampoline is copied I believe
> > and only executed in real mode without page tables.
> > 
> > So it's perhaps not the trampoline, but the early startup 
> > code that ends up being broken.
> yes :
> acpi wakeup code and smp trampoline are copied in low memory (first
> 1MB).
> 
> So they can't end up int the kernel data mapping ?
> 
> So it should something else.
> 
> I will try to investigate on this.
> 
Unfortunately on my laptop supporting NX, suspend to ram seems broken
(even without this patch) and I got only one core, so I am unable to
test it.

Does cpu suspend/resume is broken ? Or it is only S3 ?

If yes, are there any interesting trace if we suspend only one core with
sysfs.

Thanks,

Matthieu
