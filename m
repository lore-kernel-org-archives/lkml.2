Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674Ab2ERC3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:29:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51947 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966624Ab2ERC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:29:45 -0400
Date: Fri, 18 May 2012 10:29:32 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.daney@cavium.com,
        tglx@linutronix.de
Subject: Re: [PATCH -rt] MIPS: Octeon: convert smp_reserve_lock to raw
 spinlock
Message-ID: <20120518022932.GA6003@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1337249709-7346-1-git-send-email-yong.zhang0@gmail.com>
 <4FB527B2.2010800@gmail.com>
 <20120517205003.GE16397@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120517205003.GE16397@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:50:03PM +0200, Ralf Baechle wrote:
> On Thu, May 17, 2012 at 09:30:42AM -0700, David Daney wrote:
> > Date:   Thu, 17 May 2012 09:30:42 -0700
> > From: David Daney <ddaney.cavm@gmail.com>
> > To: Yong Zhang <yong.zhang0@gmail.com>, ralf@linux-mips.org
> > CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
> >  david.daney@cavium.com, tglx@linutronix.de
> > Subject: Re: [PATCH -rt] MIPS: Octeon: convert smp_reserve_lock to raw
> >  spinlock
> > Content-Type: text/plain; charset=ISO-8859-1; format=flowed
> > 
> > On 05/17/2012 03:15 AM, Yong Zhang wrote:
> > >From: Yong Zhang<yong.zhang@windriver.com>
> > >
> > >Because __cpu_disable is called in atomic context and spinlock
> > >is a mutex on -rt.
> > >
> > >Signed-off-by: Yong Zhang<yong.zhang0@gmail.com>
> > >---
> > >  arch/mips/cavium-octeon/smp.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > >
> > >diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> > >index ef9c34a..473c72b 100644
> > >--- a/arch/mips/cavium-octeon/smp.c
> > >+++ b/arch/mips/cavium-octeon/smp.c
> > >@@ -257,7 +257,7 @@ DEFINE_PER_CPU(int, cpu_state);
> > >
> > >  extern void fixup_irqs(void);
> > >
> > >-static DEFINE_SPINLOCK(smp_reserve_lock);
> > >+static DEFINE_RAW_SPINLOCK(smp_reserve_lock);
> > >
> > 
> > Ralf added this in 773cb77d (MIPS: Cavium: Add CPU hotplugging code.)
> > 
> > I'm not even sure what this lock is supposed to be protecting, so I
> > would like Ralf to take a look.
> > 
> > You can add an Acked-by: from me for either this patch as is, or if
> > Ralf thinks it is OK, removing the lock entirely.
> > 
> > In any event we can merge this via Ralf's tree.
> 
> The 773cb77d patch has a long history but I think I first worked on it for
> Wind River Linux 2.0 which was 2.6.21-based, then broke it out and pushed
> it upstream.  In 2.6.21 it was probably infected by the the smp_reserve_lock
> virus in the s390 code for no good reason.  So I agree, the lock can
> be dropped and I'm queueing a patch to do so for 3.5.

I'm OK with dropping it ;-)

Thanks,
Yong
