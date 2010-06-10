Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162Ab0FJN6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:58:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0FJN6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:58:12 -0400
Date: Thu, 10 Jun 2010 09:57:32 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 10/13] jump label v9: convert jump label to use a key
Message-ID: <20100610135732.GC2410@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
 <2a7e0be296375cf6658647c8a9c6cb208d875ac8.1276116186.git.jbaron@redhat.com>
 <1276173826.2077.252.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276173826.2077.252.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 02:43:46PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> > -static inline int enable_jump_label(const char *name)
> > -{
> > -       return 0;
> > -}
> > -
> > -static inline int disable_jump_label(const char *name)
> > -{
> > -       return 0;
> > -}
> > +#define enable_jump_label(key)
> > +#define disable_jump_label(key) 
> 
> I would expect enable_jump_label() to look something like:
> 
> #define enable_jump_label(cond_var)	\
> do {					\
> 	*(cond_var) = 1;		\
> } while (0)
> 
> That way the HAVE_JUMP_LABEL and !HAVE_JUMP_LABEL code has similar
> effects.

right. I was going to clean that up in a followup. But you are right - I
think it makes the code much clearer. will fix.

thanks,

-Jason
