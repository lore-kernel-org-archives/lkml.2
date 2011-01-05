Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1AEVTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 16:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab1AEVTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 16:19:48 -0500
Date: Wed, 5 Jan 2011 16:19:00 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jump label: make enable/disable o(1)
Message-ID: <20110105211859.GF2896@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <94bc7e748f6de41466c742b18cf4e09a34f82d69.1294239591.git.jbaron@redhat.com> <1294248665.26623.30.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294248665.26623.30.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 12:31:05PM -0500, Steven Rostedt wrote:
> On Wed, 2011-01-05 at 10:43 -0500, Jason Baron wrote:
> >  
> > +struct jump_label_key {
> > +	int state;
> > +};
> > +
> >  #define JUMP_LABEL(key, label)			\
> >  do {						\
> > -	if (unlikely(*key))			\
> > +	if (unlikely(((struct jump_label_key *)key)->state))		\
> >  		goto label;			\
> >  } while (0)
> 
> Anything that uses JUMP_LABEL() should pass in a pointer to a struct
> jump_label_key. Hence, remove the typecast. That can only lead to hard
> to find bugs.
> 
> -- Steve
> 
> 

right. The second patch in the series converts the  JUMP_LABEL() macro -> 
static __always_inline bool static_branch(struct jump_label_key *key).

So, that addresses this concern.

thanks,

-Jason
