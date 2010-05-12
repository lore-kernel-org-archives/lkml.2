Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0ELU0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0ELU0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:26:45 -0400
Date: Wed, 12 May 2010 16:26:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
 softlockup_tick removal
Message-ID: <20100512202628.GK15159@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
 <1273266711-18706-3-git-send-email-dzickus@redhat.com>
 <20100512200652.GF10028@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512200652.GF10028@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:06:54PM +0200, Frederic Weisbecker wrote:
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 1083897..1fec781 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -827,15 +827,6 @@ static struct ctl_table kern_table[] = {
> >  		.extra1		= &zero,
> >  		.extra2		= &one,
> >  	},
> > -	{
> > -		.procname	= "softlockup_thresh",
> > -		.data		= &softlockup_thresh,
> > -		.maxlen		= sizeof(int),
> > -		.mode		= 0644,
> > -		.proc_handler	= proc_dosoftlockup_thresh,
> > -		.extra1		= &neg_one,
> > -		.extra2		= &sixty,
> > -	},
> 
> 
> 
> I wonder about the ABI breakage.
> 
> But I suspect few userspace tools use it though, since this is
> mostly for kernel dev.

There is no breakage, this chunk of code was duplicated later in the file.
I am just removing the duplicated bits to simplify the SOFTLOCKUP Kconfig
stuff.

Cheers,
Don
