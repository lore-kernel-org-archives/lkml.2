Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0LDNjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 08:39:03 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40224 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0LDNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 08:39:01 -0500
Date: Sat, 4 Dec 2010 08:38:55 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH 09/15] ftrace: fix event alignment: skb:kfree_skb
Message-ID: <20101204133855.GA2388@localhost.localdomain>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-10-git-send-email-dhsharp@google.com>
 <1291427525.16223.11.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291427525.16223.11.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -3.3 (---)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 08:52:05PM -0500, Steven Rostedt wrote:
> [ Ccing Neil for Acked-by ]
> 
> -- Steve
> 
> 
Looks good, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>


> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
> > Signed-off-by: David Sharp <dhsharp@google.com>
> > ---
> >  include/trace/events/skb.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > index 75ce9d5..aa4a56a 100644
> > --- a/include/trace/events/skb.h
> > +++ b/include/trace/events/skb.h
> > @@ -19,16 +19,16 @@ TRACE_EVENT(kfree_skb,
> >  
> >  	TP_STRUCT__entry(
> >  		__field(	void *,		skbaddr		)
> > -		__field(	unsigned short,	protocol	)
> >  		__field(	void *,		location	)
> > +		__field(	unsigned short,	protocol	)
> >  	),
> >  
> >  	TP_fast_assign(
> >  		__entry->skbaddr = skb;
> > +		__entry->location = location;
> >  		if (skb) {
> >  			__entry->protocol = ntohs(skb->protocol);
> >  		}
> > -		__entry->location = location;
> >  	),
> >  
> >  	TP_printk("skbaddr=%p protocol=%u location=%p",
> 
> 
> 
