Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1AEN0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:26:09 -0500
Received: from mail.openrapids.net ([64.15.138.104]:34455 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926Ab1AEN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:26:08 -0500
Date: Wed, 5 Jan 2011 08:26:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
Message-ID: <20110105132604.GA31831@Krystal>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com> <20110104235418.GD2911@nowhere> <20110105004038.GB9737@Krystal> <20110105004903.GF2911@nowhere> <20110105012123.GA10416@Krystal> <20110105115908.GA4434@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105115908.GA4434@hmsreliant.think-freely.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:25:36 up 42 days, 18:28,  1 user,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Neil Horman (nhorman@tuxdriver.com) wrote:
[...]
> > trace event skb remove duplicate null-pointer check
> > 
> > The check for NULL skb in the kfree_skb trace event is a duplicate from the
> > check already done in its only caller, kfree_skb(). Remove this duplicate check.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: Steven Rostedt <rostedt@goodmis.org>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > ---
> >  include/trace/events/skb.h |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Index: linux-2.6-lttng/include/trace/events/skb.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/trace/events/skb.h
> > +++ linux-2.6-lttng/include/trace/events/skb.h
> > @@ -25,9 +25,7 @@ TRACE_EVENT(kfree_skb,
> >  
> >  	TP_fast_assign(
> >  		__entry->skbaddr = skb;
> > -		if (skb) {
> > -			__entry->protocol = ntohs(skb->protocol);
> > -		}
> > +		__entry->protocol = ntohs(skb->protocol);
> >  		__entry->location = location;
> >  	),
> >  
> > 
> > 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Thanks!

Mathieu

> 
> > -- 
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com
> > 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
