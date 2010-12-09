Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0LINdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:33:15 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56537 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0LINdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gf5q1o5/dpRi45uf7pF3ZQBT0KbJxD0WldAlyJ7x+Wwj3feS1Xd6XNRh2GhSt5R5K4
         IoKS0fnUhxWndHjJVRcIyGFYLGUMNdYjW6Yxyp57uM8i7mpPsi2+jjaxVFWwqpFO3ZNO
         TXS5zBtNizhwiqUcXOERdQCkftCYh0nhXcVsY=
Date: Thu, 9 Dec 2010 14:33:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 08/15] ftrace: fix event alignment: mce:mce_record
Message-ID: <20101209133303.GB1712@nowhere>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-9-git-send-email-dhsharp@google.com>
 <1291427422.16223.10.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291427422.16223.10.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 08:50:22PM -0500, Steven Rostedt wrote:
> [ Ccing Hidetoshi and Frederic for Acked-by's ]

No problem for me.

Thanks.

> -- Steve
> 
> 
> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> > Signed-off-by: David Sharp <dhsharp@google.com>
> > ---
> >  include/trace/events/mce.h |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
> > index 7eee778..4cbbcef 100644
> > --- a/include/trace/events/mce.h
> > +++ b/include/trace/events/mce.h
> > @@ -17,36 +17,36 @@ TRACE_EVENT(mce_record,
> >  	TP_STRUCT__entry(
> >  		__field(	u64,		mcgcap		)
> >  		__field(	u64,		mcgstatus	)
> > -		__field(	u8,		bank		)
> >  		__field(	u64,		status		)
> >  		__field(	u64,		addr		)
> >  		__field(	u64,		misc		)
> >  		__field(	u64,		ip		)
> > -		__field(	u8,		cs		)
> >  		__field(	u64,		tsc		)
> >  		__field(	u64,		walltime	)
> >  		__field(	u32,		cpu		)
> >  		__field(	u32,		cpuid		)
> >  		__field(	u32,		apicid		)
> >  		__field(	u32,		socketid	)
> > +		__field(	u8,		cs		)
> > +		__field(	u8,		bank		)
> >  		__field(	u8,		cpuvendor	)
> >  	),
> >  
> >  	TP_fast_assign(
> >  		__entry->mcgcap		= m->mcgcap;
> >  		__entry->mcgstatus	= m->mcgstatus;
> > -		__entry->bank		= m->bank;
> >  		__entry->status		= m->status;
> >  		__entry->addr		= m->addr;
> >  		__entry->misc		= m->misc;
> >  		__entry->ip		= m->ip;
> > -		__entry->cs		= m->cs;
> >  		__entry->tsc		= m->tsc;
> >  		__entry->walltime	= m->time;
> >  		__entry->cpu		= m->extcpu;
> >  		__entry->cpuid		= m->cpuid;
> >  		__entry->apicid		= m->apicid;
> >  		__entry->socketid	= m->socketid;
> > +		__entry->cs		= m->cs;
> > +		__entry->bank		= m->bank;
> >  		__entry->cpuvendor	= m->cpuvendor;
> >  	),
> >  
> 
> 
