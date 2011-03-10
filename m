Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab1CJOsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:48:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1CJOr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:47:59 -0500
Date: Thu, 10 Mar 2011 09:46:56 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
Message-ID: <20110310144656.GA2896@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299728191.15854.319.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:36:31PM -0500, Steven Rostedt wrote:
> > Hi,
> > 
> > Re-fresh of updates against latest -tip tree.
> 
> Thanks Jason,
> 
> I started looking at them, I should have comments tomorrow (if I have
> any comments ;)
> 
> > 
> > I've tried to split this update up somewhat, but I've only succeeded to split
> > out the dynamic debug bits. The interface changes and re-write are quite
> > intertwined.
> > 
> > I believe this update should address all the comments from the previous posting
> > except for Mathieu's request for a section of jump label pointers that point to
> > the jump label structures (since the compiler might leave gaps in the jump label
> > structures).
> 
> The jump label structures is a list of 3 pointers, correct? I doubt that
> gcc would place any holes in it as they are all aligned by natural word
> size.
> 

yes:

<address to patch>
<address to jump to (when enabled)>
<key value (which is a pointer address)>

> >  I've got a prototype patch to address this issue but its somewhat
> > invasive, and thus I'd like to leave it as a follow-up item. I have to date,
> > not seen this issue in practice.
> > 
> > thanks,
> > 
> > -Jason
> > 
> > 
> > Jason Baron (2):
> >   jump label: introduce static_branch() interface
> >   dynamic debug: add jump label support
> > 
> >  arch/mips/include/asm/jump_label.h  |   22 +-
> >  arch/mips/kernel/jump_label.c       |    2 +-
> 
> Could we get Ralf's acked-by for the mips code.
> 
> >  arch/sparc/include/asm/jump_label.h |   25 +-
> 
> Could we get David Miller's Acked-by for sparc.
> 
> Thanks,
> 
> -- Steve
> 

Ok, I'll ping them.

thanks,

-Jason
