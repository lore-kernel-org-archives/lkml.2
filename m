Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1COBgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:36:46 -0400
Received: from www.tglx.de ([62.245.132.106]:44716 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1COBgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:36:45 -0400
Date: Tue, 15 Mar 2011 02:35:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        int-list-linux-mm@kvack.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 0/20] 0: Inode based uprobes
In-Reply-To: <y0maagxuqx6.fsf@fche.csb>
Message-ID: <alpine.LFD.2.00.1103150224260.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314163028.a05cec49.akpm@linux-foundation.org> <y0maagxuqx6.fsf@fche.csb>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Frank Ch. Eigler wrote:
> akpm wrote:
> 
> > [...]  How do you envisage these features actually get used?
> 
> Patch #20/20 in the set includes an ftrace-flavoured debugfs frontend.

And you really think that:

# cd /sys/kernel/debug/tracing/

# cat /proc/`pgrep  zsh`/maps | grep /bin/zsh | grep r-xp
00400000-0048a000 r-xp 00000000 08:03 130904 /bin/zsh

# objdump -T /bin/zsh | grep -w zfree
0000000000446420 g    DF .text  0000000000000012  Base        zfree

# echo 'p /bin/zsh:0x46420 %ip %ax' > uprobe_events

# cat uprobe_events
p:uprobes/p_zsh_0x46420 /bin/zsh:0x0000000000046420

> TODO: Documentation/trace/uprobetrace.txt

without a reasonable documentation how to use that is a brilliant
argument?

> Previous versions of the patchset included perf front-ends too, which
> are probably to be seen again.

Ahh, probably. What does that mean?

     And if that probably happens, what interface is that supposed to
     use?

	The above magic wrapped into perf ?

	Or some sensible implementation ?

Thanks,

	tglx
