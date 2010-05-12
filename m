Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0ELVAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:00:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35972 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0ELVAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:00:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u4BpUpuePKS5wlR2hgd+sw2dIuCbYjyAs0AqzITb9Tv74ibY7OZiz+9Df1iSMdTCIw
         645lpBI0ayI09H2Za7TP06H8w1WI1ter76bjUuXzEVDdllk7TMM2QoXOzLpEwoGOO4+9
         ugf3Eda3BQw5B+ax+5KlPk5TyTMyzkqRy4tK4=
Date: Wed, 12 May 2010 23:00:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and
	softlockup_tick removal
Message-ID: <20100512210034.GH10028@nowhere>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com> <1273266711-18706-3-git-send-email-dzickus@redhat.com> <20100512200652.GF10028@nowhere> <20100512202628.GK15159@redhat.com> <20100512202832.GG10028@nowhere> <20100512205616.GL15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512205616.GL15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 04:56:16PM -0400, Don Zickus wrote:
> On Wed, May 12, 2010 at 10:28:35PM +0200, Frederic Weisbecker wrote:
> > On Wed, May 12, 2010 at 04:26:28PM -0400, Don Zickus wrote:
> > > On Wed, May 12, 2010 at 10:06:54PM +0200, Frederic Weisbecker wrote:
> > > > > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > > > > index 1083897..1fec781 100644
> > > > > --- a/kernel/sysctl.c
> > > > > +++ b/kernel/sysctl.c
> > > > > @@ -827,15 +827,6 @@ static struct ctl_table kern_table[] = {
> > > > >  		.extra1		= &zero,
> > > > >  		.extra2		= &one,
> > > > >  	},
> > > > > -	{
> > > > > -		.procname	= "softlockup_thresh",
> > > > > -		.data		= &softlockup_thresh,
> > > > > -		.maxlen		= sizeof(int),
> > > > > -		.mode		= 0644,
> > > > > -		.proc_handler	= proc_dosoftlockup_thresh,
> > > > > -		.extra1		= &neg_one,
> > > > > -		.extra2		= &sixty,
> > > > > -	},
> > > > 
> > > > 
> > > > 
> > > > I wonder about the ABI breakage.
> > > > 
> > > > But I suspect few userspace tools use it though, since this is
> > > > mostly for kernel dev.
> > > 
> > > There is no breakage, this chunk of code was duplicated later in the file.
> > > I am just removing the duplicated bits to simplify the SOFTLOCKUP Kconfig
> > > stuff.
> > > 
> > > Cheers,
> > > Don
> > 
> > 
> > Ah right.
> > 
> > BTW, if you address my reviews, please do it incrementally, I'm going
> > to apply this set and push it to Ingo.
> 
> Ok, probably easier to review too. :-)


Yeah, and it's time to flush this code as it's good globally.

Plus it would be nice to get this for .35

Ah and forget about the sysctl ABI breakages. Since this is only
used for kernel development, this is not going to break much things.
If somebody complains, we can still reintegrate what we had.

Thanks.

