Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0CVUli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0CVUlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:41:36 -0400
Date: Mon, 22 Mar 2010 16:40:48 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH 3/5] jump label: x86 support
Message-ID: <20100322204048.GD2278@redhat.com>
References: <cover.1269272444.git.jbaron@redhat.com> <5492858ead53ab5c67d11acc620001abe8d36bcb.1269272444.git.jbaron@redhat.com> <1269276025.2957.5.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269276025.2957.5.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 12:40:25PM -0400, Steven Rostedt wrote:
> > add x86 support for jump label. I'm keeping this patch separate so its clear to
> > arch maintainers what was required for x86 support this new feature. hopefully,
> > it wouldn't be too painful for other arches.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> 
> > +#ifdef __HAVE_ARCH_JUMP_LABEL
> > +
> > +# ifdef CONFIG_X86_64
> > +#  define JUMP_LABEL_NOP P6_NOP5
> > +# else
> > +#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
> > +# endif
> 
> Are you sure P6_NOP5 can't happen on non 64bit? Just because it is not
> configured does not mean that the CPU can not handle it. Look at the
> code I did in arch/x86/kernel/ftrace.c to determine what nop to use.
> Maybe we can make that generic and have at boot up, the kernel determine
> a proper 5byte nop.
> 

indeed, i've looked at the ftrace nop code...I think was concerned that
I would need a baseline nop that would work for all boxes. But I guess a
jmp + 5 would be it?

-Jason
