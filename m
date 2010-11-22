Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0KVQgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:36:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59630 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0KVQgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:36:00 -0500
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
From: Peter Zijlstra <peterz@infradead.org>
To: castet.matthieu@free.fr
Cc: Lin Ming <ming.m.lin@intel.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1290443379.4cea9a73cd9ce@imp.free.fr>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
	 <1290431008.2072.119.camel@laptop>  <1290443379.4cea9a73cd9ce@imp.free.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 17:35:58 +0100
Message-ID: <1290443758.2072.318.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 17:29 +0100, castet.matthieu@free.fr wrote:
> Hi,
> 
> Quoting Peter Zijlstra <peterz@infradead.org>:
> 
> > On Mon, 2010-11-22 at 15:23 +0800, Lin Ming wrote:
> > > Hi, all
> > >
> > > Current -tip tree(92c883a) fail to resume after suspend to mem.
> > > Bisect to commit 5bd5a45(x86: Add NX protection for kernel data).
> >
> > Drad, if only I'd looked at LKML before I did the bisection myself..
> >
> > > commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > > Author: Matthieu Castet <castet.matthieu@free.fr>
> > > Date:   Tue Nov 16 22:31:26 2010 +0100
> > >
> > >     x86: Add NX protection for kernel data
> > >
> > >
> > > I did some debug and found the regression is caused by below line.
> > >
> > > -       set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
> > > +       set_memory_nx(rodata_start, (kernel_end - rodata_start) >>
> > PAGE_SHIFT);
> >
> >
> > Confirmed, with that hunk reverted my machine works again..
> >
> Ok,
> I will submit a proper fix :
> in acpi_save_state_mem/acpi_restore_state_mem make the trampoline X or NX.

That seems to be a S3 specific code path, that won't fix anything.
Simply do:

echo 0 > /sys/devices/system/cpu/cpu1/online;
echo 1 > /sys/devices/system/cpu/cpu1/online;

and your machine will explode..


