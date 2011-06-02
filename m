Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1FBRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:21:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab1FBRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:21:22 -0400
Date: Thu, 2 Jun 2011 10:21:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [Patch] cris: add missing declaration of kgdb_init() and
 breakpoint()
Message-Id: <20110602102142.b8d76f33.akpm@linux-foundation.org>
In-Reply-To: <20110602143141.GD4416@cr0.redhat.com>
References: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
	<20110601151618.15759bfb.akpm@linux-foundation.org>
	<20110602143141.GD4416@cr0.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 22:31:41 +0800 Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jun 01, 2011 at 03:16:18PM -0700, Andrew Morton wrote:
> >On Sun, 22 May 2011 22:42:56 +0800
> >Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> --- a/arch/cris/arch-v10/kernel/irq.c
> >> +++ b/arch/cris/arch-v10/kernel/irq.c
> >> @@ -20,6 +20,9 @@
> >>  #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
> >>  #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
> >>  
> >> +extern void kgdb_init(void);
> >> +extern void breakpoint(void);
> >
> >They should be declared in a header file, please. 
> >arch/cris/arch-v32/kernel/irq.c has a private declaration of
> >kgdb_init(), too.
> >
> 
> Yeah, but I don't find a proper header to declare them.

Don't be afraid to create a new file!  If that's the appropriate thing
to do, it's probably the correct thing to do.

z:/usr/src/25> find . -name kgdb.h
./arch/x86/include/asm/kgdb.h
./arch/blackfin/include/asm/kgdb.h
./arch/mn10300/include/asm/kgdb.h
./arch/arm/include/asm/kgdb.h
./arch/microblaze/include/asm/kgdb.h
./arch/sparc/include/asm/kgdb.h
./arch/powerpc/include/asm/kgdb.h
./arch/mips/include/asm/kgdb.h
./arch/sh/include/asm/kgdb.h
./include/config/have/arch/kgdb.h
./include/config/kgdb.h
./include/linux/kgdb.h

I'd follow the herd and create arch/cris/include/asm/kgdb.h.
