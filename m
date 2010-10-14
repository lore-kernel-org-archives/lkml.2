Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0JNRbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:31:13 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:37526 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0JNRbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:31:11 -0400
Subject: Re: [PATCH] mutex: Introduce mutex_cpu_relax()
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1287071960.29097.284.camel@twins>
References: <1287070392.8344.15.camel@thinkpad>
	 <1287071960.29097.284.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 19:31:05 +0200
Message-ID: <1287077465.8344.47.camel@thinkpad>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 2010-10-14 at 17:59 +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-14 at 17:33 +0200, Gerald Schaefer wrote:
> 
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -100,6 +100,7 @@ config S390
> >  	select HAVE_KERNEL_BZIP2
> >  	select HAVE_KERNEL_LZMA
> >  	select HAVE_KERNEL_LZO
> > +	select HAVE_MUTEX_CPU_RELAX
> >  	select ARCH_INLINE_SPIN_TRYLOCK
> >  	select ARCH_INLINE_SPIN_TRYLOCK_BH
> >  	select ARCH_INLINE_SPIN_LOCK
> 
> >  
> > +#ifndef HAVE_MUTEX_CPU_RELAX
> > +#define mutex_cpu_relax()	cpu_relax()
> > +#endif
> 
> Won't KConfig make CONFIG_HAVE_MUTEX_CPU_RELAX from that?
> 
> Also, don't you have to first create a dummy Kconfig variable before you
> select it?

Of course you're right. I first used a #define in a header file,
but decided to rather use the Kconfig approach to avoid header
file dependency problems, should have been more careful with that.

I'll send a new patch.


