Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab2BAXP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:15:57 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47552 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2BAXPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:15:55 -0500
Date: Wed, 1 Feb 2012 15:15:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, anton@samba.org, ben@decadent.org.uk,
        mikey@neuling.org
Subject: Re: [PATCH] powerpc: Define cpus_in_crash only for SMP kernels
Message-ID: <20120201231550.GO2382@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201185510.GA8542@linux.vnet.ibm.com>
 <4F29A072.9050203@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F29A072.9050203@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020123-7182-0000-0000-000000A4043C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:28:34PM -0500, Paul Gortmaker wrote:
> On 12-02-01 01:55 PM, Paul E. McKenney wrote:
> > The variable cpus_in_crash gets a defined-but-not-used warning when
> > CONFIG_SMP=n, so fix by placing the variable under ifdef.
> 
> I think Ben already merged a similar fix.
> 
> http://patchwork.ozlabs.org/patch/136549/
> 
> P.

Linus's tree does now have cpus_in_crash, so agreed.  Sorry for the
noise!

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> > index 28be345..eb3384e 100644
> > --- a/arch/powerpc/kernel/crash.c
> > +++ b/arch/powerpc/kernel/crash.c
> > @@ -46,7 +46,9 @@
> >  
> >  /* This keeps a track of which one is the crashing cpu. */
> >  int crashing_cpu = -1;
> > +#ifdef CONFIG_SMP
> >  static atomic_t cpus_in_crash;
> > +#endif /* #ifdef CONFIG_SMP */
> >  static int time_to_dump;
> >  
> >  #define CRASH_HANDLER_MAX 3
> > 
> 

