Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0KVQ3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:29:51 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:43517 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0KVQ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:29:50 -0500
Message-ID: <1290443379.4cea9a73cd9ce@imp.free.fr>
Date: Mon, 22 Nov 2010 17:29:39 +0100
From: castet.matthieu@free.fr
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection for kernel data)
References: <1290410581.2405.24.camel@minggr.sh.intel.com> <1290431008.2072.119.camel@laptop>
In-Reply-To: <1290431008.2072.119.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.148.21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quoting Peter Zijlstra <peterz@infradead.org>:

> On Mon, 2010-11-22 at 15:23 +0800, Lin Ming wrote:
> > Hi, all
> >
> > Current -tip tree(92c883a) fail to resume after suspend to mem.
> > Bisect to commit 5bd5a45(x86: Add NX protection for kernel data).
>
> Drad, if only I'd looked at LKML before I did the bisection myself..
>
> > commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > Author: Matthieu Castet <castet.matthieu@free.fr>
> > Date:   Tue Nov 16 22:31:26 2010 +0100
> >
> >     x86: Add NX protection for kernel data
> >
> >
> > I did some debug and found the regression is caused by below line.
> >
> > -       set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
> > +       set_memory_nx(rodata_start, (kernel_end - rodata_start) >>
> PAGE_SHIFT);
>
>
> Confirmed, with that hunk reverted my machine works again..
>
Ok,
I will submit a proper fix :
in acpi_save_state_mem/acpi_restore_state_mem make the trampoline X or NX.


Matthieu
