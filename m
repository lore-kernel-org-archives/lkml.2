Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2C1PNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab2C1PNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:13:13 -0400
Date: Wed, 28 Mar 2012 11:12:30 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        rostedt@goodmis.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, mjw@redhat.com
Subject: Re: [PATCH 04/15] perf: Add ability to dump user regs
Message-ID: <20120328151230.GF4826@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com> <1332938158-5244-5-git-send-email-jolsa@redhat.com> <20120328140115.GE4826@redhat.com> <20120328142021.GC1647@m.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328142021.GC1647@m.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jiri -

> [...]
> > [...]  Upon a normal syscall entry to the kernel, not
> > all user registers are saved explicitly for such easy retrieval.  The
> > others may be spilled to the stack by gcc during the various sys_*
> > functions or elsewhere.  [...]
> 
> Are you reffering to x86_64 where only portion of registers
> is stored by SAVE_ARGS macro? Seems like 32 bits stores the
> whole pt_regs.

I believe that's the right area.  I'm not sure even the 32-bit variant
is complete enough, for example exempting MMX/SSE registers.  These
may also contain spilled registers before long.


> Generally you could need all the registers to start the unwind, but
> I was assuming that for most cases the stack pointer and instruction
> pointer should be enough.. but I might be wrong here.

Yeah; the question is how much is missed besides those "most cases".


> > To recover these registers at run time, we found that the kernel
> > stack itself has to be partially unwound [... Without that, it ...]
> > may accidentally pass garbage data to perf userspace.  Correcting
> > this could require a kernel-space libunwind.

> AFAIK not going to happen any time soon ;)

Understood.  Then the code needs to ensure that it does not purport to
pass register values that it does not know.  (Back when we were at
this stage in systemtap, we got some reasonable backtraces even
without kernel unwinding, ie. tolerating missing registers.)


- FChE
