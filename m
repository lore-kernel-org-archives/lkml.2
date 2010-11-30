Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0K3E6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:58:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:28515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab0K3E6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:58:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="862576011"
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
From: Lin Ming <ming.m.lin@intel.com>
To: mat <castet.matthieu@free.fr>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <20101126183144.300a71a4@mat-laptop>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	 <1290431008.2072.119.camel@laptop>	<1290443379.4cea9a73cd9ce@imp.free.fr>
	 <1290443758.2072.318.camel@laptop>	<20101122164247.GC21836@basil.fritz.box>
	 <20101123235527.54293b59@mat-laptop>  <20101126183144.300a71a4@mat-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 13:00:30 +0800
Message-ID: <1291093230.2405.191.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-27 at 01:31 +0800, mat wrote:
> Le Tue, 23 Nov 2010 23:55:27 +0100,
> mat <castet.matthieu@free.fr> a écrit :
> 
> > Le Mon, 22 Nov 2010 17:42:47 +0100,
> > Andi Kleen <andi@firstfloor.org> a écrit :
> > 
> > > > That seems to be a S3 specific code path, that won't fix anything.
> > > > Simply do:
> > > > 
> > > > echo 0 > /sys/devices/system/cpu/cpu1/online;
> > > > echo 1 > /sys/devices/system/cpu/cpu1/online;
> > > > 
> > > > and your machine will explode..
> > > 
> > > The SMP startup trampoline is copied I believe
> > > and only executed in real mode without page tables.
> > > 
> > > So it's perhaps not the trampoline, but the early startup 
> > > code that ends up being broken.
> > yes :
> > acpi wakeup code and smp trampoline are copied in low memory (first
> > 1MB).
> > 
> > So they can't end up int the kernel data mapping ?
> > 
> > So it should something else.
> > 
> > I will try to investigate on this.
> > 
> Unfortunately on my laptop supporting NX, suspend to ram seems broken
> (even without this patch) and I got only one core, so I am unable to
> test it.
> 
> Does cpu suspend/resume is broken ? Or it is only S3 ?
> 
> If yes, are there any interesting trace if we suspend only one core with
> sysfs.

echo 0 > /sys/devices/system/cpu/cpu1/online;
echo 1 > /sys/devices/system/cpu/cpu1/online;

then machine just reboots...

> 
> Thanks,
> 
> Matthieu


