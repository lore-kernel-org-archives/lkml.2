Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0DIVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab0DIVhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:37:50 -0400
Date: Fri, 9 Apr 2010 17:37:01 -0400
From: Jason Baron <jbaron@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 0/9] jump label v6
Message-ID: <20100409213701.GC2774@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com> <4BBF8FC8.9050707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBF8FC8.9050707@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:36:24PM -0400, Masami Hiramatsu wrote:
> Hi Jason,
> 
> Jason Baron wrote:
> > Hi,
> > 
> > Refresh of jump labeling patches aginst -tip tree. For bacground see: 
> > http://marc.info/?l=linux-kernel&m=125858436505941&w=2
> > 
> > I believe I've addressed all the reviews from v5.
> > 
> > Changes in v6:
> > 
> > * I've moved Steve Rostedt's 'ftrace_dyn_arch_init()' to alternative.c to
> > put it into a common area for used by both ftrace and jump labels. By
> > default we put a 'jmp 5' in the nop slot. Then, when we detect the best
> > runtime no-op we patch over the 'jmp 5' with the appropriate nop.
> > 
> > * build time sort of the jump label table. The jump label table is more
> > optimally accessed if the entries are continguous. Sorting the table
> > accomplishes this. Do the sort at build-time. Adds a '-j' option to 
> > 'modpost' which replaces the vmlinux, with a sorted jump label section vmlinux.
> > I've tested this on x86 with relocatable and it works fine there as well. Note
> > that I have not sorted the jump label table in modules. This is b/c the jump
> > label names can be exported by the core kernel, and thus I don't have them
> > available at buildtime. This could be solved by either finding the correct
> > ones in the vmlinux, or by embedding the name of the jump label in the module
> > tables (and not just a pointer), but the module tables tend to be smaller, and
> > thus there is less value to this kind of change anyway. The kernel continues to
> > do the sort, just in case, but at least for the vmlinux, this is just a
> > verfication b/c the jump label table has already been sorted.
> > 
> > * added jump_label_text_reserved(), so that other routines that want to patch
> > the code, can first verify that they are not stomping on jump label addresses.
> 
> Good!:-)
> So now, it might be a good time to integrate those text_reserved() functions.
> 
> BTW, how many jumps would you expect modifying at once?
> Since the text_poke_smp() uses stop_machine() for each modifying text,
> I found that it can cause a delay issue if it is called so many times...
> (e.g. a systemtap testcase sets ~5000 probes at once)
> 
> Thank you,
> 

I'm counting 934 jump label locations in the vmlinux, i have compiled,
675 of them being 'kmalloc'. Batch mode for text_poke_smp()?

-Jason
