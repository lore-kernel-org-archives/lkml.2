Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952Ab0J2Uzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:55:44 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:37459 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab0J2Uzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:55:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABvQykxGGOIS/2dsb2JhbAChUHLAHYVIBA
Date: Fri, 29 Oct 2010 16:05:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        David Daney <ddaney@caviumnetworks.com>, rth@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101029200538.GA25682@Krystal>
References: <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com> <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com> <20101028201112.GA4792@redhat.com> <20101029063450.GE29463@elte.hu> <1288354687.18238.433.camel@gandalf.stny.rr.com> <20101029122230.GA25663@elte.hu> <1288356418.18238.454.camel@gandalf.stny.rr.com> <20101029133524.GA23916@Krystal> <1288369108.29632.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1288369108.29632.1.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 16:05:22 up 205 days,  5:55,  3 users,  load average: 0.27, 0.15,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Fri, 2010-10-29 at 09:35 -0400, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
>  
> > > Then in the code have:
> > > 
> > > -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
> > > +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL) \
> > 
> > Technically, you could remove the dependency on
> > "defined(CONFIG_HAVE_ARCH_JUMP_LABEL)", because it is now dealt with at
> > the Kconfig level (CONFIG_JUMP_LABEL depends on it).
> 
> Yeah, I noticed that just after hitting send.
> 
> > 
> > > +	&& defined(JUMP_LABEL)
> > 
> > this would be defined(CONFIG_JUMP_LABEL)
> 
> Yep, this too, but thanks for pointing it out.
> 
> 
> > 
> > The rest looks fine,
> 
> Great, can I add your acked-by then?

As noted in my other email, please do :)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
